Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1051BC8A2
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgD1SeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbgD1SeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D80E20B80;
        Tue, 28 Apr 2020 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098851;
        bh=VgkjHnQqDZCRXFMl2MkI/WnEv6n7OOoH66nseVDHmXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYKTxWQvL17q+u/qjlc9uLDnpjLdCRJmgtwVpQZKBegMZ3Qa7+Dhqy/f5uX8bOv+C
         0Yq9Rd2m1wrQnSt0z6XQZTgp/c6f5EIWjd14XsQVqJyWqUlrCTG26LJfIn0wxasUDe
         M27wYc9G2zP+msSR8VSAl8xBPXHVZHL27SNqAtvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+49e69b4d71a420ceda3e@syzkaller.appspotmail.com,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.6 120/167] audit: check the length of userspace generated audit records
Date:   Tue, 28 Apr 2020 20:24:56 +0200
Message-Id: <20200428182240.405262148@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -1326,6 +1326,9 @@ static int audit_receive_msg(struct sk_b
 	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
 		if (!audit_enabled && msg_type != AUDIT_USER_AVC)
 			return 0;
+		/* exit early if there isn't at least one character to print */
+		if (data_len < 2)
+			return -EINVAL;
 
 		err = audit_filter(msg_type, AUDIT_FILTER_USER);
 		if (err == 1) { /* match or error */


