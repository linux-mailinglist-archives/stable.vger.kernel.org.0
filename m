Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F081B4A42A2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358835AbiAaLMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57936 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377823AbiAaLKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C65BB82A4E;
        Mon, 31 Jan 2022 11:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4866AC340E8;
        Mon, 31 Jan 2022 11:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627428;
        bh=spdpjo4qMbBRvJtQh7H28I1jbdknu9a8xKiGy/yHeJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBkloCJ2TAOo5K6auD+V86zOHr9skp5Kdi2IBide/p2tGH+ZK6UxRMaQsJSZnq+yZ
         Mf2zFJE3FMW/CCD9mjp6vDKQlinqLWrn4JHEOnFLtOa7T1VuZ3+sEqDACsQe53Wcl9
         z3ndwf57THPJKeE9b0bwa6SOZBpKWRkvO+SQ9CT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.15 080/171] usb: roles: fix include/linux/usb/role.h compile issue
Date:   Mon, 31 Jan 2022 11:55:45 +0100
Message-Id: <20220131105232.741088302@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -92,6 +92,12 @@ fwnode_usb_role_switch_get(struct fwnode
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


