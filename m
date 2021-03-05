Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8051032E976
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhCEMc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhCEMcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DF56501A;
        Fri,  5 Mar 2021 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947565;
        bh=7TDKmWeaGn7XLJ2yiG+Xc3Z/4UpCGKpkm5kqgBNubEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0wGxk1SCSU2auodEdTK54MiKJ5C0fWSJBJmdJ/J0JhIO9FRfae18H09CncWhugwv
         eKJ9jjHKZVGVs868V87oMRy+Q3t4XP+o6ofAWpOTSQBoEQt8SQvoZudd511QhQHw+9
         36yJLtM9zVDN8rDBZb/za9fOvzoB5O2UuvEiggXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Nichols <adam@grimm-co.com>,
        Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 083/102] scsi: iscsi: Restrict sessions and handles to admin capabilities
Date:   Fri,  5 Mar 2021 13:21:42 +0100
Message-Id: <20210305120907.364742631@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

commit 688e8128b7a92df982709a4137ea4588d16f24aa upstream.

Protect the iSCSI transport handle, available in sysfs, by requiring
CAP_SYS_ADMIN to read it. Also protect the netlink socket by restricting
reception of messages to ones sent with CAP_SYS_ADMIN. This disables
normal users from being able to end arbitrary iSCSI sessions.

Cc: stable@vger.kernel.org
Reported-by: Adam Nichols <adam@grimm-co.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_transport_iscsi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -132,6 +132,9 @@ show_transport_handle(struct device *dev
 		      char *buf)
 {
 	struct iscsi_internal *priv = dev_to_iscsi_internal(dev);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
 	return sprintf(buf, "%llu\n", (unsigned long long)iscsi_handle(priv->iscsi_transport));
 }
 static DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
@@ -3624,6 +3627,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep = NULL;
 
+	if (!netlink_capable(skb, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (nlh->nlmsg_type == ISCSI_UEVENT_PATH_UPDATE)
 		*group = ISCSI_NL_GRP_UIP;
 	else


