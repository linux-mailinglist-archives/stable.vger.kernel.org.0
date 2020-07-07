Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6D6217170
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgGGPTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgGGPTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0417120771;
        Tue,  7 Jul 2020 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135178;
        bh=3loIWrb/NTdHYT6B7PNpKetRiuw0Wl9KsYLsh/tir7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuKhk0nTXBKCNe7cq14gmgbkf6PiMpNQEnVFMDg8TZHLdviKgXAN3a3e40T3e8Zfz
         3X8zODv+pbyqwdwyXFzVBdPrkU8x/YRFJyX1NjJm8vBMFF3LcJFydoYYna4VUmCQL8
         ZOghau6PHy33L4KZvGrkQ3jsRWkx2bN/ObTlShms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Aurich <paul@darkrain42.org>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 4.19 30/36] SMB3: Honor persistent/resilient handle flags for multiuser mounts
Date:   Tue,  7 Jul 2020 17:17:22 +0200
Message-Id: <20200707145750.597622665@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Aurich <paul@darkrain42.org>

commit 00dfbc2f9c61185a2e662f27c45a0bb29b2a134f upstream.

Without this:

- persistent handles will only be enabled for per-user tcons if the
  server advertises the 'Continuous Availabity' capability
- resilient handles would never be enabled for per-user tcons

Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4601,6 +4601,8 @@ cifs_construct_tcon(struct cifs_sb_info
 	vol_info->nocase = master_tcon->nocase;
 	vol_info->nohandlecache = master_tcon->nohandlecache;
 	vol_info->local_lease = master_tcon->local_lease;
+	vol_info->resilient = master_tcon->use_resilient;
+	vol_info->persistent = master_tcon->use_persistent;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
 	vol_info->linux_ext = master_tcon->posix_extensions;
 	vol_info->sectype = master_tcon->ses->sectype;


