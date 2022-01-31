Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D4C4A4194
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358930AbiAaLEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:04:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358874AbiAaLDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:03:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74B89B82A63;
        Mon, 31 Jan 2022 11:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EC2C340E8;
        Mon, 31 Jan 2022 11:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627011;
        bh=TU0p7qkeeXgylcewjx6eQ6XV10JW5uxp5Lh3IIbzWWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFSVR5CNBgu6YCrVA/RHuYh4rwwQC4ou85D5SQYbD0c841tSU3jjq8sIJJf2Cn2/C
         +ZvW6Ap1Q2XLailHvMuUhlMdhzfhaWNj/cENN7hUUe48YLQ9oQRVHHyDFRyabBH2x5
         6aMRcJZxjkM6Vp9nDJ+GWJAGkMu7CmjcHGlGpgKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.10 047/100] usb: roles: fix include/linux/usb/role.h compile issue
Date:   Mon, 31 Jan 2022 11:56:08 +0100
Message-Id: <20220131105222.023753472@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <quic_linyyuan@quicinc.com>

commit 945c37ed564770c78dfe6b9f08bed57a1b4e60ef upstream.

when CONFIG_USB_ROLE_SWITCH is not defined,
add usb_role_switch_find_by_fwnode() definition which return NULL.

Fixes: c6919d5e0cd1 ("usb: roles: Add usb_role_switch_find_by_fwnode()")
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1641818608-25039-1-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/usb/role.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/usb/role.h
+++ b/include/linux/usb/role.h
@@ -91,6 +91,12 @@ fwnode_usb_role_switch_get(struct fwnode
 static inline void usb_role_switch_put(struct usb_role_switch *sw) { }
 
 static inline struct usb_role_switch *
+usb_role_switch_find_by_fwnode(const struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
+static inline struct usb_role_switch *
 usb_role_switch_register(struct device *parent,
 			 const struct usb_role_switch_desc *desc)
 {


