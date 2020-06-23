Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EA205D54
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388433AbgFWUMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388915AbgFWUL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE6F20707;
        Tue, 23 Jun 2020 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943115;
        bh=Zrzb55GW5PmHP0MjbOglbQ2SDEcE9bSNuLt6zq3WD4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yG5W0aiIAqP+NfTF+Zrpu6rUByExUXHmqE4+XwIMUW+NkM21S6+6cVTIDaPdsOuYh
         4oXe0CCNRbFCPyl12wgw0VCU9BQjcL41hGh53fi+h+LtH0vFqLrpabHYZgQAi+h+nJ
         f2/nuD3t8tNQXwDGzomQQOxQ+ricsgJgZxAMKNLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jayshri Pawar <jpawar@cadence.com>,
        Pawel Laszczak <pawell@cadence.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 264/477] usb: gadget: Fix issue with config_ep_by_speed function
Date:   Tue, 23 Jun 2020 21:54:21 +0200
Message-Id: <20200623195420.044538801@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 5d363120aa548ba52d58907a295eee25f8207ed2 ]

This patch adds new config_ep_by_speed_and_alt function which
extends the config_ep_by_speed about alt parameter.
This additional parameter allows to find proper usb_ss_ep_comp_descriptor.

Problem has appeared during testing f_tcm (BOT/UAS) driver function.

f_tcm function for SS use array of headers for both  BOT/UAS alternate
setting:

static struct usb_descriptor_header *uasp_ss_function_desc[] = {
        (struct usb_descriptor_header *) &bot_intf_desc,
        (struct usb_descriptor_header *) &uasp_ss_bi_desc,
        (struct usb_descriptor_header *) &bot_bi_ep_comp_desc,
        (struct usb_descriptor_header *) &uasp_ss_bo_desc,
        (struct usb_descriptor_header *) &bot_bo_ep_comp_desc,

        (struct usb_descriptor_header *) &uasp_intf_desc,
        (struct usb_descriptor_header *) &uasp_ss_bi_desc,
        (struct usb_descriptor_header *) &uasp_bi_ep_comp_desc,
        (struct usb_descriptor_header *) &uasp_bi_pipe_desc,
        (struct usb_descriptor_header *) &uasp_ss_bo_desc,
        (struct usb_descriptor_header *) &uasp_bo_ep_comp_desc,
        (struct usb_descriptor_header *) &uasp_bo_pipe_desc,
        (struct usb_descriptor_header *) &uasp_ss_status_desc,
        (struct usb_descriptor_header *) &uasp_status_in_ep_comp_desc,
        (struct usb_descriptor_header *) &uasp_status_pipe_desc,
        (struct usb_descriptor_header *) &uasp_ss_cmd_desc,
        (struct usb_descriptor_header *) &uasp_cmd_comp_desc,
        (struct usb_descriptor_header *) &uasp_cmd_pipe_desc,
        NULL,
};

The first 5 descriptors are associated with BOT alternate setting,
and others are associated with UAS.

During handling UAS alternate setting f_tcm driver invokes
config_ep_by_speed and this function sets incorrect companion endpoint
descriptor in usb_ep object.

Instead setting ep->comp_desc to uasp_bi_ep_comp_desc function in this
case set ep->comp_desc to uasp_ss_bi_desc.

This is due to the fact that it searches endpoint based on endpoint
address:

        for_each_ep_desc(speed_desc, d_spd) {
                chosen_desc = (struct usb_endpoint_descriptor *)*d_spd;
                if (chosen_desc->bEndpoitAddress == _ep->address)
                        goto ep_found;
        }

And in result it uses the descriptor from BOT alternate setting
instead UAS.

Finally, it causes that controller driver during enabling endpoints
detect that just enabled endpoint for bot.

Signed-off-by: Jayshri Pawar <jpawar@cadence.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 78 ++++++++++++++++++++++++++--------
 include/linux/usb/composite.h  |  3 ++
 2 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index cb4950cf1cdcb..5c1eb96a5c571 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -96,40 +96,43 @@ function_descriptors(struct usb_function *f,
 }
 
 /**
- * next_ep_desc() - advance to the next EP descriptor
+ * next_desc() - advance to the next desc_type descriptor
  * @t: currect pointer within descriptor array
+ * @desc_type: descriptor type
  *
- * Return: next EP descriptor or NULL
+ * Return: next desc_type descriptor or NULL
  *
- * Iterate over @t until either EP descriptor found or
+ * Iterate over @t until either desc_type descriptor found or
  * NULL (that indicates end of list) encountered
  */
 static struct usb_descriptor_header**
-next_ep_desc(struct usb_descriptor_header **t)
+next_desc(struct usb_descriptor_header **t, u8 desc_type)
 {
 	for (; *t; t++) {
-		if ((*t)->bDescriptorType == USB_DT_ENDPOINT)
+		if ((*t)->bDescriptorType == desc_type)
 			return t;
 	}
 	return NULL;
 }
 
 /*
- * for_each_ep_desc()- iterate over endpoint descriptors in the
- *		descriptors list
- * @start:	pointer within descriptor array.
- * @ep_desc:	endpoint descriptor to use as the loop cursor
+ * for_each_desc() - iterate over desc_type descriptors in the
+ * descriptors list
+ * @start: pointer within descriptor array.
+ * @iter_desc: desc_type descriptor to use as the loop cursor
+ * @desc_type: wanted descriptr type
  */
-#define for_each_ep_desc(start, ep_desc) \
-	for (ep_desc = next_ep_desc(start); \
-	      ep_desc; ep_desc = next_ep_desc(ep_desc+1))
+#define for_each_desc(start, iter_desc, desc_type) \
+	for (iter_desc = next_desc(start, desc_type); \
+	     iter_desc; iter_desc = next_desc(iter_desc + 1, desc_type))
 
 /**
- * config_ep_by_speed() - configures the given endpoint
+ * config_ep_by_speed_and_alt() - configures the given endpoint
  * according to gadget speed.
  * @g: pointer to the gadget
  * @f: usb function
  * @_ep: the endpoint to configure
+ * @alt: alternate setting number
  *
  * Return: error code, 0 on success
  *
@@ -142,11 +145,13 @@ next_ep_desc(struct usb_descriptor_header **t)
  * Note: the supplied function should hold all the descriptors
  * for supported speeds
  */
-int config_ep_by_speed(struct usb_gadget *g,
-			struct usb_function *f,
-			struct usb_ep *_ep)
+int config_ep_by_speed_and_alt(struct usb_gadget *g,
+				struct usb_function *f,
+				struct usb_ep *_ep,
+				u8 alt)
 {
 	struct usb_endpoint_descriptor *chosen_desc = NULL;
+	struct usb_interface_descriptor *int_desc = NULL;
 	struct usb_descriptor_header **speed_desc = NULL;
 
 	struct usb_ss_ep_comp_descriptor *comp_desc = NULL;
@@ -182,8 +187,21 @@ int config_ep_by_speed(struct usb_gadget *g,
 	default:
 		speed_desc = f->fs_descriptors;
 	}
+
+	/* find correct alternate setting descriptor */
+	for_each_desc(speed_desc, d_spd, USB_DT_INTERFACE) {
+		int_desc = (struct usb_interface_descriptor *)*d_spd;
+
+		if (int_desc->bAlternateSetting == alt) {
+			speed_desc = d_spd;
+			goto intf_found;
+		}
+	}
+	return -EIO;
+
+intf_found:
 	/* find descriptors */
-	for_each_ep_desc(speed_desc, d_spd) {
+	for_each_desc(speed_desc, d_spd, USB_DT_ENDPOINT) {
 		chosen_desc = (struct usb_endpoint_descriptor *)*d_spd;
 		if (chosen_desc->bEndpointAddress == _ep->address)
 			goto ep_found;
@@ -237,6 +255,32 @@ ep_found:
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(config_ep_by_speed_and_alt);
+
+/**
+ * config_ep_by_speed() - configures the given endpoint
+ * according to gadget speed.
+ * @g: pointer to the gadget
+ * @f: usb function
+ * @_ep: the endpoint to configure
+ *
+ * Return: error code, 0 on success
+ *
+ * This function chooses the right descriptors for a given
+ * endpoint according to gadget speed and saves it in the
+ * endpoint desc field. If the endpoint already has a descriptor
+ * assigned to it - overwrites it with currently corresponding
+ * descriptor. The endpoint maxpacket field is updated according
+ * to the chosen descriptor.
+ * Note: the supplied function should hold all the descriptors
+ * for supported speeds
+ */
+int config_ep_by_speed(struct usb_gadget *g,
+			struct usb_function *f,
+			struct usb_ep *_ep)
+{
+	return config_ep_by_speed_and_alt(g, f, _ep, 0);
+}
 EXPORT_SYMBOL_GPL(config_ep_by_speed);
 
 /**
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 8675e145ea8b3..2040696d75b6e 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -249,6 +249,9 @@ int usb_function_activate(struct usb_function *);
 
 int usb_interface_id(struct usb_configuration *, struct usb_function *);
 
+int config_ep_by_speed_and_alt(struct usb_gadget *g, struct usb_function *f,
+				struct usb_ep *_ep, u8 alt);
+
 int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
 			struct usb_ep *_ep);
 
-- 
2.25.1



