Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1729681053
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbjA3OCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbjA3OCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:02:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4083B0D0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F4137B81178
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D2AC4339B;
        Mon, 30 Jan 2023 14:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087327;
        bh=SWPCtv2MM3/QUmnINGlz1oL5Vgb4E1JPK4qbtJCM+gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJxejt22puhRpOR6VHWLhKhlna5uEAQd/UpdR3e0GeFOKrkjIt0ujHjC2iqxqcwZr
         JiffDdzvmYyQTSE9SmW1EOd4bzARGYeVpS1cMpzqQ7obhgHjcnl5Ll5kS4JjTV0zmG
         KrOOfqVGVGEEZoKayaHKcze1R9877vyWSg1Ny5Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Hao <haowenchao@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/313] scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace
Date:   Mon, 30 Jan 2023 14:49:36 +0100
Message-Id: <20230130134343.224009811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenchao Hao <haowenchao@huawei.com>

[ Upstream commit a3be19b91ea7121d388084e8c07f5b1b982eb40c ]

It was observed that the kernel would potentially send
ISCSI_KEVENT_UNBIND_SESSION multiple times. Introduce 'target_state' in
iscsi_cls_session() to make sure session will send only one unbind session
event.

This introduces a regression wrt. the issue fixed in commit 13e60d3ba287
("scsi: iscsi: Report unbind session event when the target has been
removed"). If iscsid dies for any reason after sending an unbind session to
kernel, once iscsid is restarted, the kernel's ISCSI_KEVENT_UNBIND_SESSION
event is lost and userspace is then unable to logout. However, the session
is actually in invalid state (its target_id is INVALID) so iscsid should
not sync this session during restart.

Consequently we need to check the session's target state during iscsid
restart.  If session is in unbound state, do not sync this session and
perform session teardown. This is OK because once a session is unbound, we
can not recover it any more (mainly because its target id is INVALID).

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
Link: https://lore.kernel.org/r/20221126010752.231917-1-haowenchao@huawei.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 50 ++++++++++++++++++++++++++---
 include/scsi/scsi_transport_iscsi.h |  9 ++++++
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f473c002fa4d..bf834e72595a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1677,6 +1677,13 @@ static const char *iscsi_session_state_name(int state)
 	return name;
 }
 
+static char *iscsi_session_target_state_name[] = {
+	[ISCSI_SESSION_TARGET_UNBOUND]   = "UNBOUND",
+	[ISCSI_SESSION_TARGET_ALLOCATED] = "ALLOCATED",
+	[ISCSI_SESSION_TARGET_SCANNED]   = "SCANNED",
+	[ISCSI_SESSION_TARGET_UNBINDING] = "UNBINDING",
+};
+
 int iscsi_session_chkready(struct iscsi_cls_session *session)
 {
 	int err;
@@ -1786,9 +1793,13 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 		if ((scan_data->channel == SCAN_WILD_CARD ||
 		     scan_data->channel == 0) &&
 		    (scan_data->id == SCAN_WILD_CARD ||
-		     scan_data->id == id))
+		     scan_data->id == id)) {
 			scsi_scan_target(&session->dev, 0, id,
 					 scan_data->lun, scan_data->rescan);
+			spin_lock_irqsave(&session->lock, flags);
+			session->target_state = ISCSI_SESSION_TARGET_SCANNED;
+			spin_unlock_irqrestore(&session->lock, flags);
+		}
 	}
 
 user_scan_exit:
@@ -1961,31 +1972,41 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 	unsigned int target_id;
+	bool remove_target = true;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unbinding session\n");
 
 	/* Prevent new scans and make sure scanning is not in progress */
 	mutex_lock(&ihost->mutex);
 	spin_lock_irqsave(&session->lock, flags);
-	if (session->target_id == ISCSI_MAX_TARGET) {
+	if (session->target_state == ISCSI_SESSION_TARGET_ALLOCATED) {
+		remove_target = false;
+	} else if (session->target_state != ISCSI_SESSION_TARGET_SCANNED) {
 		spin_unlock_irqrestore(&session->lock, flags);
 		mutex_unlock(&ihost->mutex);
-		goto unbind_session_exit;
+		ISCSI_DBG_TRANS_SESSION(session,
+			"Skipping target unbinding: Session is unbound/unbinding.\n");
+		return;
 	}
 
+	session->target_state = ISCSI_SESSION_TARGET_UNBINDING;
 	target_id = session->target_id;
 	session->target_id = ISCSI_MAX_TARGET;
 	spin_unlock_irqrestore(&session->lock, flags);
 	mutex_unlock(&ihost->mutex);
 
-	scsi_remove_target(&session->dev);
+	if (remove_target)
+		scsi_remove_target(&session->dev);
 
 	if (session->ida_used)
 		ida_free(&iscsi_sess_ida, target_id);
 
-unbind_session_exit:
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
+
+	spin_lock_irqsave(&session->lock, flags);
+	session->target_state = ISCSI_SESSION_TARGET_UNBOUND;
+	spin_unlock_irqrestore(&session->lock, flags);
 }
 
 static void __iscsi_destroy_session(struct work_struct *work)
@@ -2062,6 +2083,9 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 		session->ida_used = true;
 	} else
 		session->target_id = target_id;
+	spin_lock_irqsave(&session->lock, flags);
+	session->target_state = ISCSI_SESSION_TARGET_ALLOCATED;
+	spin_unlock_irqrestore(&session->lock, flags);
 
 	dev_set_name(&session->dev, "session%u", session->sid);
 	err = device_add(&session->dev);
@@ -4369,6 +4393,19 @@ iscsi_session_attr(def_taskmgmt_tmo, ISCSI_PARAM_DEF_TASKMGMT_TMO, 0);
 iscsi_session_attr(discovery_parent_idx, ISCSI_PARAM_DISCOVERY_PARENT_IDX, 0);
 iscsi_session_attr(discovery_parent_type, ISCSI_PARAM_DISCOVERY_PARENT_TYPE, 0);
 
+static ssize_t
+show_priv_session_target_state(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(dev->parent);
+
+	return sysfs_emit(buf, "%s\n",
+			iscsi_session_target_state_name[session->target_state]);
+}
+
+static ISCSI_CLASS_ATTR(priv_sess, target_state, S_IRUGO,
+			show_priv_session_target_state, NULL);
+
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
 			char *buf)
@@ -4471,6 +4508,7 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_boot_target.attr,
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
+	&dev_attr_priv_sess_target_state.attr,
 	&dev_attr_priv_sess_creator.attr,
 	&dev_attr_sess_chap_out_idx.attr,
 	&dev_attr_sess_chap_in_idx.attr,
@@ -4584,6 +4622,8 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
 		return S_IRUGO;
+	else if (attr == &dev_attr_priv_sess_target_state.attr)
+		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_creator.attr)
 		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_target_id.attr)
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index cab52b0f11d0..34c03707fb6e 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -236,6 +236,14 @@ enum {
 	ISCSI_SESSION_FREE,
 };
 
+enum {
+	ISCSI_SESSION_TARGET_UNBOUND,
+	ISCSI_SESSION_TARGET_ALLOCATED,
+	ISCSI_SESSION_TARGET_SCANNED,
+	ISCSI_SESSION_TARGET_UNBINDING,
+	ISCSI_SESSION_TARGET_MAX,
+};
+
 #define ISCSI_MAX_TARGET -1
 
 struct iscsi_cls_session {
@@ -264,6 +272,7 @@ struct iscsi_cls_session {
 	 */
 	pid_t creator;
 	int state;
+	int target_state;			/* session target bind state */
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */
-- 
2.39.0



