Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A211013329B
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgAGVM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:12:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgAGVLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:11:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E655620880;
        Tue,  7 Jan 2020 21:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431466;
        bh=LdXKwXpcbTa3rC8S+Y33KNh47g7MBqbYl8yPsEXg4kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRAkhfD6/ZMgoxLTq9S6omZwISl5iY6pbhXzJ03uAfAdULppnGJfJ9IkNs93weSsq
         uJ4V5xGvopp1Ad1D9XUWvui+MEebsbQfuLaUvJnwjGlpj48iUdhvpWRk8Hb2D+k3Rm
         PFFeE7L4WwY1Hu6GFF/s9Zd2s296WfKIUeHhZsMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Yashkin <a.yashkin@inango-systems.com>,
        Nikolay Merinov <n.merinov@inango-systems.com>,
        Ariel Gilman <a.gilman@inango-systems.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.14 31/74] pstore/ram: Write new dumps to start of recycled zones
Date:   Tue,  7 Jan 2020 21:54:56 +0100
Message-Id: <20200107205201.534099388@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksandr Yashkin <a.yashkin@inango-systems.com>

commit 9e5f1c19800b808a37fb9815a26d382132c26c3d upstream.

The ram_core.c routines treat przs as circular buffers. When writing a
new crash dump, the old buffer needs to be cleared so that the new dump
doesn't end up in the wrong place (i.e. at the end).

The solution to this problem is to reset the circular buffer state before
writing a new Oops dump.

Signed-off-by: Aleksandr Yashkin <a.yashkin@inango-systems.com>
Signed-off-by: Nikolay Merinov <n.merinov@inango-systems.com>
Signed-off-by: Ariel Gilman <a.gilman@inango-systems.com>
Link: https://lore.kernel.org/r/20191223133816.28155-1-n.merinov@inango-systems.com
Fixes: 896fc1f0c4c6 ("pstore/ram: Switch to persistent_ram routines")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/ram.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -433,6 +433,17 @@ static int notrace ramoops_pstore_write(
 
 	prz = cxt->dprzs[cxt->dump_write_cnt];
 
+	/*
+	 * Since this is a new crash dump, we need to reset the buffer in
+	 * case it still has an old dump present. Without this, the new dump
+	 * will get appended, which would seriously confuse anything trying
+	 * to check dump file contents. Specifically, ramoops_read_kmsg_hdr()
+	 * expects to find a dump header in the beginning of buffer data, so
+	 * we must to reset the buffer values, in order to ensure that the
+	 * header will be written to the beginning of the buffer.
+	 */
+	persistent_ram_zap(prz);
+
 	/* Build header and append record contents. */
 	hlen = ramoops_write_kmsg_hdr(prz, record);
 	size = record->size;


