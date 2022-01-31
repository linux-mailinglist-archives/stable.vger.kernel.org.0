Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD704A452F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377897AbiAaLhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378475AbiAaLeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795AAC02B8D5;
        Mon, 31 Jan 2022 03:22:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD8361120;
        Mon, 31 Jan 2022 11:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65D7C340E8;
        Mon, 31 Jan 2022 11:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628133;
        bh=spdpjo4qMbBRvJtQh7H28I1jbdknu9a8xKiGy/yHeJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ2zBE/+9cS948Yfrw/20IOdC+jOTTs2O1FHu3BkzK5v+mf+S1Dx8M/MiOTzR+FNZ
         aqDvJSniJ56rQ/ekffFQi0wFA7x0aC70tIzp5yFcuIhVFgo2cNWOBRYo6FhjrAiEk3
         626goWzujzExna3ruKJaJovd6+dIILZrELlVj7VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.16 101/200] usb: roles: fix include/linux/usb/role.h compile issue
Date:   Mon, 31 Jan 2022 11:56:04 +0100
Message-Id: <20220131105236.990284031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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


