Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477DD3A6457
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhFNLXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235081AbhFNLVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ABEA6199C;
        Mon, 14 Jun 2021 10:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667928;
        bh=cTfb+w7TafjN96srb5yUS/4AqjOJf/Z69ZTCAqZQoAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPXZxZXrTeIGn++Tq8Axj6aDFgL9YzZW1U9n+Q+xeOU3qi8L2iXkUEdN/416OiokM
         JLRAGX+E7A5vC2FkCsof8XFdHiBr/7dRpN5jQGGfG7OmgaxwJF0MAUjte2wYjDNe/R
         tYkt+fYdvvt9dZMcInSoyDJ+Ose+D3HZ7NzyHkZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.12 128/173] usb: typec: mux: Fix copy-paste mistake in typec_mux_match
Date:   Mon, 14 Jun 2021 12:27:40 +0200
Message-Id: <20210614102702.427460893@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 142d0b24c1b17139f1aaaacae7542a38aa85640f upstream.

Fix the copy-paste mistake in the return path of typec_mux_match(),
where dev is considered a member of struct typec_switch rather than
struct typec_mux.

The two structs are identical in regards to having the struct device as
the first entry, so this provides no functional change.

Fixes: 3370db35193b ("usb: typec: Registering real device entries for the muxes")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210610002132.3088083-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -239,7 +239,7 @@ find_mux:
 	dev = class_find_device(&typec_mux_class, NULL, fwnode,
 				mux_fwnode_match);
 
-	return dev ? to_typec_switch(dev) : ERR_PTR(-EPROBE_DEFER);
+	return dev ? to_typec_mux(dev) : ERR_PTR(-EPROBE_DEFER);
 }
 
 /**


