Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0429BA54
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1804885AbgJ0P7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803541AbgJ0PxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:53:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1555204EF;
        Tue, 27 Oct 2020 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813983;
        bh=C8rYlUmh1Ae4Ca7S9/v5W1ha5nhTvIZBybPzxQxBtUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZ9GjX3l6T3ZL3bqY2x62Bajv6suA/WLZdg+slHbPIsBF6MpQZ4hDtNCel9UC/PIg
         B2k4gidRxjxgNo9tTDl77ibgzWHTeo0EHz714J18xrr4oJrga7gGcIkiwkuGyEMD3Q
         VIx5i7CMHq9fhOGvdC+N0d8gHz9JB8itB2EDyp6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Teel <scott.teel@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>,
        Martin Wilck <mwilck@suse.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 736/757] scsi: smartpqi: Avoid crashing kernel for controller issues
Date:   Tue, 27 Oct 2020 14:56:26 +0100
Message-Id: <20201027135525.026606932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

[ Upstream commit 9e68cccc8ef7206f0bccd590378d0dca8f9b4f57 ]

Eliminate kernel panics when getting invalid responses from controller.
Take controller offline instead of causing kernel panics.

Link: https://lore.kernel.org/r/159622929306.30579.16523318707596752828.stgit@brunhilda
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Prasad Munirathnam <Prasad.Munirathnam@microsemi.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 101 +++++++++++++++++---------
 2 files changed, 68 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 1129fe7a27edd..ee069a8b442a7 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -359,7 +359,7 @@ struct pqi_event_response {
 	struct pqi_iu_header header;
 	u8	event_type;
 	u8	reserved2 : 7;
-	u8	request_acknowlege : 1;
+	u8	request_acknowledge : 1;
 	__le16	event_id;
 	__le32	additional_event_id;
 	union {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ca1e6cf6a38ef..714a3d38fc431 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -542,8 +542,7 @@ static int pqi_build_raid_path_request(struct pqi_ctrl_info *ctrl_info,
 		put_unaligned_be16(cdb_length, &cdb[7]);
 		break;
 	default:
-		dev_err(&ctrl_info->pci_dev->dev, "unknown command 0x%c\n",
-			cmd);
+		dev_err(&ctrl_info->pci_dev->dev, "unknown command 0x%c\n", cmd);
 		break;
 	}
 
@@ -2462,7 +2461,6 @@ static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 		offload_to_mirror =
 			(offload_to_mirror >= layout_map_count - 1) ?
 				0 : offload_to_mirror + 1;
-		WARN_ON(offload_to_mirror >= layout_map_count);
 		device->offload_to_mirror = offload_to_mirror;
 		/*
 		 * Avoid direct use of device->offload_to_mirror within this
@@ -2915,10 +2913,14 @@ static int pqi_interpret_task_management_response(
 	return rc;
 }
 
-static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_queue_group *queue_group)
+static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info)
+{
+	pqi_take_ctrl_offline(ctrl_info);
+}
+
+static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue_group *queue_group)
 {
-	unsigned int num_responses;
+	int num_responses;
 	pqi_index_t oq_pi;
 	pqi_index_t oq_ci;
 	struct pqi_io_request *io_request;
@@ -2930,6 +2932,13 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 
 	while (1) {
 		oq_pi = readl(queue_group->oq_pi);
+		if (oq_pi >= ctrl_info->num_elements_per_oq) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"I/O interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
+				oq_pi, ctrl_info->num_elements_per_oq - 1, oq_ci);
+			return -1;
+		}
 		if (oq_pi == oq_ci)
 			break;
 
@@ -2938,10 +2947,22 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 			(oq_ci * PQI_OPERATIONAL_OQ_ELEMENT_LENGTH);
 
 		request_id = get_unaligned_le16(&response->request_id);
-		WARN_ON(request_id >= ctrl_info->max_io_slots);
+		if (request_id >= ctrl_info->max_io_slots) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"request ID in response (%u) out of range (0-%u): producer index: %u  consumer index: %u\n",
+				request_id, ctrl_info->max_io_slots - 1, oq_pi, oq_ci);
+			return -1;
+		}
 
 		io_request = &ctrl_info->io_request_pool[request_id];
-		WARN_ON(atomic_read(&io_request->refcount) == 0);
+		if (atomic_read(&io_request->refcount) == 0) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"request ID in response (%u) does not match an outstanding I/O request: producer index: %u  consumer index: %u\n",
+				request_id, oq_pi, oq_ci);
+			return -1;
+		}
 
 		switch (response->header.iu_type) {
 		case PQI_RESPONSE_IU_RAID_PATH_IO_SUCCESS:
@@ -2971,24 +2992,22 @@ static unsigned int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info,
 			io_request->error_info = ctrl_info->error_buffer +
 				(get_unaligned_le16(&response->error_index) *
 				PQI_ERROR_BUFFER_ELEMENT_LENGTH);
-			pqi_process_io_error(response->header.iu_type,
-				io_request);
+			pqi_process_io_error(response->header.iu_type, io_request);
 			break;
 		default:
+			pqi_invalid_response(ctrl_info);
 			dev_err(&ctrl_info->pci_dev->dev,
-				"unexpected IU type: 0x%x\n",
-				response->header.iu_type);
-			break;
+				"unexpected IU type: 0x%x: producer index: %u  consumer index: %u\n",
+				response->header.iu_type, oq_pi, oq_ci);
+			return -1;
 		}
 
-		io_request->io_complete_callback(io_request,
-			io_request->context);
+		io_request->io_complete_callback(io_request, io_request->context);
 
 		/*
 		 * Note that the I/O request structure CANNOT BE TOUCHED after
 		 * returning from the I/O completion callback!
 		 */
-
 		oq_ci = (oq_ci + 1) % ctrl_info->num_elements_per_oq;
 	}
 
@@ -3300,9 +3319,9 @@ static void pqi_ofa_capture_event_payload(struct pqi_event *event,
 	}
 }
 
-static unsigned int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
+static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 {
-	unsigned int num_events;
+	int num_events;
 	pqi_index_t oq_pi;
 	pqi_index_t oq_ci;
 	struct pqi_event_queue *event_queue;
@@ -3316,26 +3335,31 @@ static unsigned int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
 
 	while (1) {
 		oq_pi = readl(event_queue->oq_pi);
+		if (oq_pi >= PQI_NUM_EVENT_QUEUE_ELEMENTS) {
+			pqi_invalid_response(ctrl_info);
+			dev_err(&ctrl_info->pci_dev->dev,
+				"event interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
+				oq_pi, PQI_NUM_EVENT_QUEUE_ELEMENTS - 1, oq_ci);
+			return -1;
+		}
+
 		if (oq_pi == oq_ci)
 			break;
 
 		num_events++;
-		response = event_queue->oq_element_array +
-			(oq_ci * PQI_EVENT_OQ_ELEMENT_LENGTH);
+		response = event_queue->oq_element_array + (oq_ci * PQI_EVENT_OQ_ELEMENT_LENGTH);
 
 		event_index =
 			pqi_event_type_to_event_index(response->event_type);
 
-		if (event_index >= 0) {
-			if (response->request_acknowlege) {
-				event = &ctrl_info->events[event_index];
-				event->pending = true;
-				event->event_type = response->event_type;
-				event->event_id = response->event_id;
-				event->additional_event_id =
-					response->additional_event_id;
+		if (event_index >= 0 && response->request_acknowledge) {
+			event = &ctrl_info->events[event_index];
+			event->pending = true;
+			event->event_type = response->event_type;
+			event->event_id = response->event_id;
+			event->additional_event_id = response->additional_event_id;
+			if (event->event_type == PQI_EVENT_TYPE_OFA)
 				pqi_ofa_capture_event_payload(event, response);
-			}
 		}
 
 		oq_ci = (oq_ci + 1) % PQI_NUM_EVENT_QUEUE_ELEMENTS;
@@ -3450,7 +3474,8 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_queue_group *queue_group;
-	unsigned int num_responses_handled;
+	int num_io_responses_handled;
+	int num_events_handled;
 
 	queue_group = data;
 	ctrl_info = queue_group->ctrl_info;
@@ -3458,17 +3483,25 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 	if (!pqi_is_valid_irq(ctrl_info))
 		return IRQ_NONE;
 
-	num_responses_handled = pqi_process_io_intr(ctrl_info, queue_group);
+	num_io_responses_handled = pqi_process_io_intr(ctrl_info, queue_group);
+	if (num_io_responses_handled < 0)
+		goto out;
 
-	if (irq == ctrl_info->event_irq)
-		num_responses_handled += pqi_process_event_intr(ctrl_info);
+	if (irq == ctrl_info->event_irq) {
+		num_events_handled = pqi_process_event_intr(ctrl_info);
+		if (num_events_handled < 0)
+			goto out;
+	} else {
+		num_events_handled = 0;
+	}
 
-	if (num_responses_handled)
+	if (num_io_responses_handled + num_events_handled > 0)
 		atomic_inc(&ctrl_info->num_interrupts);
 
 	pqi_start_io(ctrl_info, queue_group, RAID_PATH, NULL);
 	pqi_start_io(ctrl_info, queue_group, AIO_PATH, NULL);
 
+out:
 	return IRQ_HANDLED;
 }
 
-- 
2.25.1



