Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463C31C136B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgEAN3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgEAN3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:29:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B977208D6;
        Fri,  1 May 2020 13:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339761;
        bh=L9W7ToVGh3TEgwhLmqWCC2AlIbFT2re0QaNSwcakZus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urVSD1gKwjKZNNJUIhPWcruwZdLBVNDfT96vxJZkaUT1ThvPIxkBsHWzmsk5DSTTV
         o3+Dluz84Y7DLAixXqBFrkxAtyt0adF/c6f1N5K4PDTTHYUlCwYvoyRSPHnLjuxcrP
         AtVxKdAPdCwAA6xXa7MAExKtpIkCA6m0KWSuYq04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+49e69b4d71a420ceda3e@syzkaller.appspotmail.com,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.9 49/80] audit: check the length of userspace generated audit records
Date:   Fri,  1 May 2020 15:21:43 +0200
Message-Id: <20200501131528.800691245@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit 763dafc520add02a1f4639b500c509acc0ea8e5b upstream.

Commit 756125289285 ("audit: always check the netlink payload length
in audit_receive_msg()") fixed a number of missing message length
checks, but forgot to check the length of userspace generated audit
records.  The good news is that you need CAP_AUDIT_WRITE to submit
userspace audit records, which is generally only given to trusted
processes, so the impact should be limited.

Cc: stable@vger.kernel.org
Fixes: 756125289285 ("audit: always check the netlink payload length in audit_receive_msg()")
Reported-by: syzbot+49e69b4d71a420ceda3e@syzkaller.appspotmail.com
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -941,6 +941,9 @@ static int audit_receive_msg(struct sk_b
 	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
+		/* exit early if there isn't at least one character to print */
+		if (data_len < 2)
+			return -EINVAL;
 
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */


