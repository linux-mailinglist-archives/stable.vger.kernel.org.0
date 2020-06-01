Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A631EA969
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgFASBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729832AbgFASBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DAF120776;
        Mon,  1 Jun 2020 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034507;
        bh=q1doY0AB3P8r/4C1MDCRprR7AsXw8tUvmzIu15oKs60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAcMDXoH5TjHbH3ejFUQCPoYXQL84QO3JJl9JS6oQeweBsQjdAlRIbmAD3xGup0ru
         o7c3BzdRSR6OWBZaOOo4QLKSmUcEkUlkMAq7Z7JZZAjUCzRy+VyE+8uOMe/asQGgjG
         CQzKvDxefzmJNXRL+rzeSp15OGO1jxj43oY+gdnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/77] samples: bpf: Fix build error
Date:   Mon,  1 Jun 2020 19:53:28 +0200
Message-Id: <20200601174020.581088545@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit 23ad04669f81f958e9a4121b0266228d2eb3c357 ]

GCC 10 is very strict about symbol clash, and lwt_len_hist_user contains
a symbol which clashes with libbpf:

/usr/bin/ld: samples/bpf/lwt_len_hist_user.o:(.bss+0x0): multiple definition of `bpf_log_buf'; samples/bpf/bpf_load.o:(.bss+0x8c0): first defined here
collect2: error: ld returned 1 exit status

bpf_log_buf here seems to be a leftover, so removing it.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200511113234.80722-1-mcroce@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/lwt_len_hist_user.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/bpf/lwt_len_hist_user.c b/samples/bpf/lwt_len_hist_user.c
index 7fcb94c09112..965108527a4f 100644
--- a/samples/bpf/lwt_len_hist_user.c
+++ b/samples/bpf/lwt_len_hist_user.c
@@ -15,8 +15,6 @@
 #define MAX_INDEX 64
 #define MAX_STARS 38
 
-char bpf_log_buf[BPF_LOG_BUF_SIZE];
-
 static void stars(char *str, long val, long max, int width)
 {
 	int i;
-- 
2.25.1



