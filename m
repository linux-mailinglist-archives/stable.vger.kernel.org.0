Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB929450F17
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbhKOS0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241179AbhKOSYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B72563420;
        Mon, 15 Nov 2021 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998866;
        bh=l78W76YJg/eYYL9/3HFaIJNL0/tgqPKabeFSnKrPSR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDkmNlbKWM4CW5eAhZH/n2fsspLxUhGHkwow1YtXSNDhGQpsluQqaTRmbSSsw2b/F
         X+NU5hEsyzRwYM1K7U2cCZNdRlF6SY5BAhsvpq8Ql2rVfbRM59YWifpbzT3CtB8AqK
         0S6YcpLXcHa7hK7nxz+7g5TPIIdv4jic2TK8Pw7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 090/849] net: hns3: change hclge/hclgevf workqueue to WQ_UNBOUND mode
Date:   Mon, 15 Nov 2021 17:52:53 +0100
Message-Id: <20211115165423.132651818@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit f29da4088fb4eeba457219a931327d1d5f45196a ]

Currently, the workqueue of hclge/hclgevf is executed on
the CPU that initiates scheduling requests by default. In
stress scenarios, the CPU may be busy and workqueue scheduling
is completed after a long period of time. To avoid this
situation and implement proper scheduling, use the WQ_UNBOUND
mode instead. In this way, the workqueue can be performed on
a relatively idle CPU.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 34 +++----------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 -
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 3 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 721eb4e92f618..dc748f2f18434 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2846,33 +2846,28 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
 
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
 
 static void hclge_errhand_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task, 0);
+		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
 
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
 	    !test_bit(HCLGE_STATE_RST_FAIL, &hdev->state))
-		mod_delayed_work_on(cpumask_first(&hdev->affinity_mask),
-				    hclge_wq, &hdev->service_task,
-				    delay_time);
+		mod_delayed_work(hclge_wq, &hdev->service_task, delay_time);
 }
 
 static int hclge_get_mac_link_status(struct hclge_dev *hdev, int *link_status)
@@ -3490,33 +3485,14 @@ static void hclge_get_misc_vector(struct hclge_dev *hdev)
 	hdev->num_msi_used += 1;
 }
 
-static void hclge_irq_affinity_notify(struct irq_affinity_notify *notify,
-				      const cpumask_t *mask)
-{
-	struct hclge_dev *hdev = container_of(notify, struct hclge_dev,
-					      affinity_notify);
-
-	cpumask_copy(&hdev->affinity_mask, mask);
-}
-
-static void hclge_irq_affinity_release(struct kref *ref)
-{
-}
-
 static void hclge_misc_affinity_setup(struct hclge_dev *hdev)
 {
 	irq_set_affinity_hint(hdev->misc_vector.vector_irq,
 			      &hdev->affinity_mask);
-
-	hdev->affinity_notify.notify = hclge_irq_affinity_notify;
-	hdev->affinity_notify.release = hclge_irq_affinity_release;
-	irq_set_affinity_notifier(hdev->misc_vector.vector_irq,
-				  &hdev->affinity_notify);
 }
 
 static void hclge_misc_affinity_teardown(struct hclge_dev *hdev)
 {
-	irq_set_affinity_notifier(hdev->misc_vector.vector_irq, NULL);
 	irq_set_affinity_hint(hdev->misc_vector.vector_irq, NULL);
 }
 
@@ -13040,7 +13016,7 @@ static int hclge_init(void)
 {
 	pr_info("%s is initializing\n", HCLGE_NAME);
 
-	hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
+	hclge_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGE_NAME);
 	if (!hclge_wq) {
 		pr_err("%s: failed to create workqueue\n", HCLGE_NAME);
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index e446b839a3715..0d0ebb9714234 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -942,7 +942,6 @@ struct hclge_dev {
 
 	/* affinity mask and notify for misc interrupt */
 	cpumask_t affinity_mask;
-	struct irq_affinity_notify affinity_notify;
 	struct hclge_ptp *ptp;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b8414f684e89d..a1713a1ce6839 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3890,7 +3890,7 @@ static int hclgevf_init(void)
 {
 	pr_info("%s is initializing\n", HCLGEVF_NAME);
 
-	hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
+	hclgevf_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGEVF_NAME);
 	if (!hclgevf_wq) {
 		pr_err("%s: failed to create workqueue\n", HCLGEVF_NAME);
 		return -ENOMEM;
-- 
2.33.0



