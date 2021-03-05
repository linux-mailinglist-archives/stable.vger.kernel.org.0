Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2BC32EA1D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhCEMge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhCEMgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:36:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C3965004;
        Fri,  5 Mar 2021 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947766;
        bh=YCyo7jLMHyREv5b4CJsE4SH9lBSX6ViiLthbpeXBfPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/139ZSwg5g62poeKjiKqpjGfbMtDPkY4goF//4CUbNwGOfUKFyRD5lbO5YrDwsGZ
         KAVFCu5uj/OzpgnpaqYaa1s/vQEvgB3VtypBspYAZXkiGtR/mEY7FZrDhdXYkNrKb0
         7UHgvEHh7AnlK/Fjh4uTUkoNxmNzLGzjnc03voeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Nichols <adam@grimm-co.com>,
        Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 61/72] scsi: iscsi: Restrict sessions and handles to admin capabilities
Date:   Fri,  5 Mar 2021 13:22:03 +0100
Message-Id: <20210305120900.323493568@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
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
@@ -124,6 +124,9 @@ show_transport_handle(struct device *dev
 		      char *buf)
 {
 	struct iscsi_internal *priv = dev_to_iscsi_internal(dev);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
 	return sprintf(buf, "%llu\n", (unsigned long long)iscsi_handle(priv->iscsi_transport));
 }
 static DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
@@ -3506,6 +3509,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep = NULL;
 
+	if (!netlink_capable(skb, CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (nlh->nlmsg_type == ISCSI_UEVENT_PATH_UPDATE)
 		*group = ISCSI_NL_GRP_UIP;
 	else


