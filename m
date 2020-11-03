Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34882A599C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgKCWI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbgKCUkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F1CE22226;
        Tue,  3 Nov 2020 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436010;
        bh=lppP0F4L6Q+mDBy2Pkz6dBCm+9+E64E7wZu2At7YZWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+PSDru/RRJeUkGUVHw/wowYCtqioG9htkLtWoha0Vj0U5wad4GRbO8a8VNAvFR5V
         4Epf9Gex6ngLjlA8wB4gLQrIIZ10EyL3cCxQaDvGWqikjScfilB3tcmtCbxLSa4t8+
         mcpwDO1ZZ1KRZkwWeSy8JUAuAbN9Dm0lb1yogDHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 057/391] s390/ap/zcrypt: revisit ap and zcrypt error handling
Date:   Tue,  3 Nov 2020 21:31:48 +0100
Message-Id: <20201103203351.265971284@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit e0332629e33d1926c93348d918aaaf451ef9a16b ]

Revisit the ap queue error handling: Based on discussions and
evaluatios with the firmware folk here is now a rework of the response
code handling for all the AP instructions. The idea is to distinguish
between failures because of some kind of invalid request where a retry
does not make any sense and a failure where another attempt to send
the very same request may succeed. The first case is handled by
returning EINVAL to the userspace application. The second case results
in retries within the zcrypt API controlled by a per message retry
counter.

Revisit the zcrpyt error handling: Similar here, based on discussions
with the firmware people here comes a rework of the handling of all
the reply codes.  Main point here is that there are only very few
cases left, where a zcrypt device queue is switched to offline. It
should never be the case that an AP reply message is 'unknown' to the
device driver as it indicates a total mismatch between device driver
and crypto card firmware. In all other cases, the code distinguishes
between failure because of invalid message (see above - EINVAL) or
failures of the infrastructure (see above - EAGAIN).

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.h           |  1 +
 drivers/s390/crypto/ap_queue.c         |  8 +--
 drivers/s390/crypto/zcrypt_debug.h     |  8 +++
 drivers/s390/crypto/zcrypt_error.h     | 88 +++++++++---------------
 drivers/s390/crypto/zcrypt_msgtype50.c | 50 +++++++-------
 drivers/s390/crypto/zcrypt_msgtype6.c  | 92 +++++++++++++-------------
 6 files changed, 116 insertions(+), 131 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 1ea046324e8f6..c4afca0d773c6 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -50,6 +50,7 @@ static inline int ap_test_bit(unsigned int *ptr, unsigned int nr)
 #define AP_RESPONSE_NO_FIRST_PART	0x13
 #define AP_RESPONSE_MESSAGE_TOO_BIG	0x15
 #define AP_RESPONSE_REQ_FAC_NOT_INST	0x16
+#define AP_RESPONSE_INVALID_DOMAIN	0x42
 
 /*
  * Known device types
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 688ebebbf98cb..99f73bbb1c751 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -237,6 +237,9 @@ static enum ap_sm_wait ap_sm_write(struct ap_queue *aq)
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		aq->sm_state = AP_SM_STATE_RESET_WAIT;
 		return AP_SM_WAIT_TIMEOUT;
+	case AP_RESPONSE_INVALID_DOMAIN:
+		AP_DBF(DBF_WARN, "AP_RESPONSE_INVALID_DOMAIN on NQAP\n");
+		fallthrough;
 	case AP_RESPONSE_MESSAGE_TOO_BIG:
 	case AP_RESPONSE_REQ_FAC_NOT_INST:
 		list_del_init(&ap_msg->list);
@@ -278,11 +281,6 @@ static enum ap_sm_wait ap_sm_reset(struct ap_queue *aq)
 		aq->sm_state = AP_SM_STATE_RESET_WAIT;
 		aq->interrupt = AP_INTR_DISABLED;
 		return AP_SM_WAIT_TIMEOUT;
-	case AP_RESPONSE_BUSY:
-		return AP_SM_WAIT_TIMEOUT;
-	case AP_RESPONSE_Q_NOT_AVAIL:
-	case AP_RESPONSE_DECONFIGURED:
-	case AP_RESPONSE_CHECKSTOPPED:
 	default:
 		aq->sm_state = AP_SM_STATE_BORKED;
 		return AP_SM_WAIT_NONE;
diff --git a/drivers/s390/crypto/zcrypt_debug.h b/drivers/s390/crypto/zcrypt_debug.h
index 241dbb5f75bf3..3225489a1c411 100644
--- a/drivers/s390/crypto/zcrypt_debug.h
+++ b/drivers/s390/crypto/zcrypt_debug.h
@@ -21,6 +21,14 @@
 
 #define ZCRYPT_DBF(...)					\
 	debug_sprintf_event(zcrypt_dbf_info, ##__VA_ARGS__)
+#define ZCRYPT_DBF_ERR(...)					\
+	debug_sprintf_event(zcrypt_dbf_info, DBF_ERR, ##__VA_ARGS__)
+#define ZCRYPT_DBF_WARN(...)					\
+	debug_sprintf_event(zcrypt_dbf_info, DBF_WARN, ##__VA_ARGS__)
+#define ZCRYPT_DBF_INFO(...)					\
+	debug_sprintf_event(zcrypt_dbf_info, DBF_INFO, ##__VA_ARGS__)
+#define ZCRYPT_DBF_DBG(...)					\
+	debug_sprintf_event(zcrypt_dbf_info, DBF_DEBUG, ##__VA_ARGS__)
 
 extern debug_info_t *zcrypt_dbf_info;
 
diff --git a/drivers/s390/crypto/zcrypt_error.h b/drivers/s390/crypto/zcrypt_error.h
index 54a04f8c38ef9..39e626e3a3794 100644
--- a/drivers/s390/crypto/zcrypt_error.h
+++ b/drivers/s390/crypto/zcrypt_error.h
@@ -52,7 +52,6 @@ struct error_hdr {
 #define REP82_ERROR_INVALID_COMMAND	    0x30
 #define REP82_ERROR_MALFORMED_MSG	    0x40
 #define REP82_ERROR_INVALID_SPECIAL_CMD	    0x41
-#define REP82_ERROR_INVALID_DOMAIN_PRECHECK 0x42
 #define REP82_ERROR_RESERVED_FIELDO	    0x50 /* old value	*/
 #define REP82_ERROR_WORD_ALIGNMENT	    0x60
 #define REP82_ERROR_MESSAGE_LENGTH	    0x80
@@ -67,7 +66,6 @@ struct error_hdr {
 #define REP82_ERROR_ZERO_BUFFER_LEN	    0xB0
 
 #define REP88_ERROR_MODULE_FAILURE	    0x10
-
 #define REP88_ERROR_MESSAGE_TYPE	    0x20
 #define REP88_ERROR_MESSAGE_MALFORMD	    0x22
 #define REP88_ERROR_MESSAGE_LENGTH	    0x23
@@ -85,78 +83,56 @@ static inline int convert_error(struct zcrypt_queue *zq,
 	int queue = AP_QID_QUEUE(zq->queue->qid);
 
 	switch (ehdr->reply_code) {
-	case REP82_ERROR_OPERAND_INVALID:
-	case REP82_ERROR_OPERAND_SIZE:
-	case REP82_ERROR_EVEN_MOD_IN_OPND:
-	case REP88_ERROR_MESSAGE_MALFORMD:
-	case REP82_ERROR_INVALID_DOMAIN_PRECHECK:
-	case REP82_ERROR_INVALID_DOMAIN_PENDING:
-	case REP82_ERROR_INVALID_SPECIAL_CMD:
-	case REP82_ERROR_FILTERED_BY_HYPERVISOR:
-	//   REP88_ERROR_INVALID_KEY		// '82' CEX2A
-	//   REP88_ERROR_OPERAND		// '84' CEX2A
-	//   REP88_ERROR_OPERAND_EVEN_MOD	// '85' CEX2A
-		/* Invalid input data. */
+	case REP82_ERROR_INVALID_MSG_LEN:	 /* 0x23 */
+	case REP82_ERROR_RESERVD_FIELD:		 /* 0x24 */
+	case REP82_ERROR_FORMAT_FIELD:		 /* 0x29 */
+	case REP82_ERROR_MALFORMED_MSG:		 /* 0x40 */
+	case REP82_ERROR_INVALID_SPECIAL_CMD:	 /* 0x41 */
+	case REP82_ERROR_MESSAGE_LENGTH:	 /* 0x80 */
+	case REP82_ERROR_OPERAND_INVALID:	 /* 0x82 */
+	case REP82_ERROR_OPERAND_SIZE:		 /* 0x84 */
+	case REP82_ERROR_EVEN_MOD_IN_OPND:	 /* 0x85 */
+	case REP82_ERROR_INVALID_DOMAIN_PENDING: /* 0x8A */
+	case REP82_ERROR_FILTERED_BY_HYPERVISOR: /* 0x8B */
+	case REP82_ERROR_PACKET_TRUNCATED:	 /* 0xA0 */
+	case REP88_ERROR_MESSAGE_MALFORMD:	 /* 0x22 */
+	case REP88_ERROR_KEY_TYPE:		 /* 0x34 */
+		/* RY indicates malformed request */
 		ZCRYPT_DBF(DBF_WARN,
-			   "device=%02x.%04x reply=0x%02x => rc=EINVAL\n",
+			   "dev=%02x.%04x RY=0x%02x => rc=EINVAL\n",
 			   card, queue, ehdr->reply_code);
 		return -EINVAL;
-	case REP82_ERROR_MESSAGE_TYPE:
-	//   REP88_ERROR_MESSAGE_TYPE		// '20' CEX2A
+	case REP82_ERROR_MACHINE_FAILURE:	 /* 0x10 */
+	case REP82_ERROR_MESSAGE_TYPE:		 /* 0x20 */
+	case REP82_ERROR_TRANSPORT_FAIL:	 /* 0x90 */
 		/*
-		 * To sent a message of the wrong type is a bug in the
-		 * device driver. Send error msg, disable the device
-		 * and then repeat the request.
+		 * Msg to wrong type or card/infrastructure failure.
+		 * Trigger rescan of the ap bus, trigger retry request.
 		 */
 		atomic_set(&zcrypt_rescan_req, 1);
-		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
-		       card, queue);
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x reply=0x%02x => online=0 rc=EAGAIN\n",
-			   card, queue, ehdr->reply_code);
-		return -EAGAIN;
-	case REP82_ERROR_TRANSPORT_FAIL:
-		/* Card or infrastructure failure, disable card */
-		atomic_set(&zcrypt_rescan_req, 1);
-		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
-		       card, queue);
 		/* For type 86 response show the apfs value (failure reason) */
-		if (ehdr->type == TYPE86_RSP_CODE) {
+		if (ehdr->reply_code == REP82_ERROR_TRANSPORT_FAIL &&
+		    ehdr->type == TYPE86_RSP_CODE) {
 			struct {
 				struct type86_hdr hdr;
 				struct type86_fmt2_ext fmt2;
 			} __packed * head = reply->msg;
 			unsigned int apfs = *((u32 *)head->fmt2.apfs);
 
-			ZCRYPT_DBF(DBF_ERR,
-				   "device=%02x.%04x reply=0x%02x apfs=0x%x => online=0 rc=EAGAIN\n",
-				   card, queue, apfs, ehdr->reply_code);
+			ZCRYPT_DBF(DBF_WARN,
+				   "dev=%02x.%04x RY=0x%02x apfs=0x%x => bus rescan, rc=EAGAIN\n",
+				   card, queue, ehdr->reply_code, apfs);
 		} else
-			ZCRYPT_DBF(DBF_ERR,
-				   "device=%02x.%04x reply=0x%02x => online=0 rc=EAGAIN\n",
+			ZCRYPT_DBF(DBF_WARN,
+				   "dev=%02x.%04x RY=0x%02x => bus rescan, rc=EAGAIN\n",
 				   card, queue, ehdr->reply_code);
 		return -EAGAIN;
-	case REP82_ERROR_MACHINE_FAILURE:
-	//   REP88_ERROR_MODULE_FAILURE		// '10' CEX2A
-		/* If a card fails disable it and repeat the request. */
-		atomic_set(&zcrypt_rescan_req, 1);
-		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
-		       card, queue);
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x reply=0x%02x => online=0 rc=EAGAIN\n",
-			   card, queue, ehdr->reply_code);
-		return -EAGAIN;
 	default:
-		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
-		       card, queue);
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x reply=0x%02x => online=0 rc=EAGAIN\n",
+		/* Assume request is valid and a retry will be worth it */
+		ZCRYPT_DBF(DBF_WARN,
+			   "dev=%02x.%04x RY=0x%02x => rc=EAGAIN\n",
 			   card, queue, ehdr->reply_code);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		return -EAGAIN;
 	}
 }
 
diff --git a/drivers/s390/crypto/zcrypt_msgtype50.c b/drivers/s390/crypto/zcrypt_msgtype50.c
index 7aedc338b4459..88916addd513e 100644
--- a/drivers/s390/crypto/zcrypt_msgtype50.c
+++ b/drivers/s390/crypto/zcrypt_msgtype50.c
@@ -356,15 +356,15 @@ static int convert_type80(struct zcrypt_queue *zq,
 	if (t80h->len < sizeof(*t80h) + outputdatalength) {
 		/* The result is too short, the CEXxA card may not do that.. */
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x code=0x%02x => online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x code=0x%02x => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   t80h->code);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       t80h->code);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x code=0x%02x => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       t80h->code);
+		return -EAGAIN;
 	}
 	if (zq->zcard->user_space_type == ZCRYPT_CEX2A)
 		BUG_ON(t80h->len > CEX2A_MAX_RESPONSE_SIZE);
@@ -376,10 +376,10 @@ static int convert_type80(struct zcrypt_queue *zq,
 	return 0;
 }
 
-static int convert_response(struct zcrypt_queue *zq,
-			    struct ap_message *reply,
-			    char __user *outputdata,
-			    unsigned int outputdatalength)
+static int convert_response_cex2a(struct zcrypt_queue *zq,
+				  struct ap_message *reply,
+				  char __user *outputdata,
+				  unsigned int outputdatalength)
 {
 	/* Response type byte is the second byte in the response. */
 	unsigned char rtype = ((unsigned char *) reply->msg)[1];
@@ -393,15 +393,15 @@ static int convert_response(struct zcrypt_queue *zq,
 				      outputdata, outputdatalength);
 	default: /* Unknown response type, this should NEVER EVER happen */
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x rtype=0x%02x => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   (unsigned int) rtype);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       (int) rtype);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       (int) rtype);
+		return -EAGAIN;
 	}
 }
 
@@ -476,8 +476,9 @@ static long zcrypt_cex2a_modexpo(struct zcrypt_queue *zq,
 	if (rc == 0) {
 		rc = ap_msg.rc;
 		if (rc == 0)
-			rc = convert_response(zq, &ap_msg, mex->outputdata,
-					      mex->outputdatalength);
+			rc = convert_response_cex2a(zq, &ap_msg,
+						    mex->outputdata,
+						    mex->outputdatalength);
 	} else
 		/* Signal pending. */
 		ap_cancel_message(zq->queue, &ap_msg);
@@ -520,8 +521,9 @@ static long zcrypt_cex2a_modexpo_crt(struct zcrypt_queue *zq,
 	if (rc == 0) {
 		rc = ap_msg.rc;
 		if (rc == 0)
-			rc = convert_response(zq, &ap_msg, crt->outputdata,
-					      crt->outputdatalength);
+			rc = convert_response_cex2a(zq, &ap_msg,
+						    crt->outputdata,
+						    crt->outputdatalength);
 	} else
 		/* Signal pending. */
 		ap_cancel_message(zq->queue, &ap_msg);
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index d77991c74c252..21ea3b73c8674 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -650,23 +650,22 @@ static int convert_type86_ica(struct zcrypt_queue *zq,
 		    (service_rc == 8 && service_rs == 72) ||
 		    (service_rc == 8 && service_rs == 770) ||
 		    (service_rc == 12 && service_rs == 769)) {
-			ZCRYPT_DBF(DBF_DEBUG,
-				   "device=%02x.%04x rc/rs=%d/%d => rc=EINVAL\n",
-				   AP_QID_CARD(zq->queue->qid),
-				   AP_QID_QUEUE(zq->queue->qid),
-				   (int) service_rc, (int) service_rs);
+			ZCRYPT_DBF_WARN("dev=%02x.%04x rc/rs=%d/%d => rc=EINVAL\n",
+					AP_QID_CARD(zq->queue->qid),
+					AP_QID_QUEUE(zq->queue->qid),
+					(int) service_rc, (int) service_rs);
 			return -EINVAL;
 		}
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x rc/rs=%d/%d online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x rc/rs=%d/%d => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   (int) service_rc, (int) service_rs);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       (int) service_rc, (int) service_rs);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x rc/rs=%d/%d => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       (int) service_rc, (int) service_rs);
+		return -EAGAIN;
 	}
 	data = msg->text;
 	reply_len = msg->length - 2;
@@ -800,17 +799,18 @@ static int convert_response_ica(struct zcrypt_queue *zq,
 			return convert_type86_ica(zq, reply,
 						  outputdata, outputdatalength);
 		fallthrough;	/* wrong cprb version is an unknown response */
-	default: /* Unknown response type, this should NEVER EVER happen */
+	default:
+		/* Unknown response type, this should NEVER EVER happen */
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x rtype=0x%02x => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   (int) msg->hdr.type);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       (int) msg->hdr.type);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       (int) msg->hdr.type);
+		return -EAGAIN;
 	}
 }
 
@@ -836,15 +836,15 @@ static int convert_response_xcrb(struct zcrypt_queue *zq,
 	default: /* Unknown response type, this should NEVER EVER happen */
 		xcRB->status = 0x0008044DL; /* HDD_InvalidParm */
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x rtype=0x%02x => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   (int) msg->hdr.type);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       (int) msg->hdr.type);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       (int) msg->hdr.type);
+		return -EAGAIN;
 	}
 }
 
@@ -865,15 +865,15 @@ static int convert_response_ep11_xcrb(struct zcrypt_queue *zq,
 		fallthrough;	/* wrong cprb version is an unknown resp */
 	default: /* Unknown response type, this should NEVER EVER happen */
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x rtype=0x%02x => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   (int) msg->hdr.type);
-		return -EAGAIN; /* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       (int) msg->hdr.type);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       (int) msg->hdr.type);
+		return -EAGAIN;
 	}
 }
 
@@ -895,15 +895,15 @@ static int convert_response_rng(struct zcrypt_queue *zq,
 		fallthrough;	/* wrong cprb version is an unknown response */
 	default: /* Unknown response type, this should NEVER EVER happen */
 		zq->online = 0;
-		pr_err("Cryptographic device %02x.%04x failed and was set offline\n",
+		pr_err("Crypto dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
 		       AP_QID_CARD(zq->queue->qid),
-		       AP_QID_QUEUE(zq->queue->qid));
-		ZCRYPT_DBF(DBF_ERR,
-			   "device=%02x.%04x rtype=0x%02x => online=0 rc=EAGAIN\n",
-			   AP_QID_CARD(zq->queue->qid),
-			   AP_QID_QUEUE(zq->queue->qid),
-			   (int) msg->hdr.type);
-		return -EAGAIN;	/* repeat the request on a different device. */
+		       AP_QID_QUEUE(zq->queue->qid),
+		       (int) msg->hdr.type);
+		ZCRYPT_DBF_ERR("dev=%02x.%04x unknown response type 0x%02x => online=0 rc=EAGAIN\n",
+			       AP_QID_CARD(zq->queue->qid),
+			       AP_QID_QUEUE(zq->queue->qid),
+			       (int) msg->hdr.type);
+		return -EAGAIN;
 	}
 }
 
-- 
2.27.0



