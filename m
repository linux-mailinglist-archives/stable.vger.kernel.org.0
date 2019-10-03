Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65126CA212
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfJCQBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbfJCQBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:01:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E138420700;
        Thu,  3 Oct 2019 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118501;
        bh=svnBraEINLjsPtQxZ9LCLJLTnzolJHZG7uWWGddNu6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHNai6HmLua8Jzx0IYm9NxMcaT1QXJ11hCA/SQoPI9ybbH4Zf/ie6KahvcaebRBXe
         oHRNdj5CfzA/aiOU9Bky6QkqzBOWxZm2lnVZHQBe3W/fF7B+RT3OlefuSsaPZE5yNy
         6hA0JkeVDOJt3Yo3HpviUH6P272JFDGGzqS4L/hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.9 032/129] usbnet: ignore endpoints with invalid wMaxPacketSize
Date:   Thu,  3 Oct 2019 17:52:35 +0200
Message-Id: <20191003154333.680194033@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 8d3d7c2029c1b360f1a6b0a2fca470b57eb575c0 ]

Endpoints with zero wMaxPacketSize are not usable for transferring
data. Ignore such endpoints when looking for valid in, out and
status pipes, to make the drivers more robust against invalid and
meaningless descriptors.

The wMaxPacketSize of these endpoints are used for memory allocations
and as divisors in many usbnet minidrivers. Avoiding zero is therefore
critical.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -114,6 +114,11 @@ int usbnet_get_endpoints(struct usbnet *
 			int				intr = 0;
 
 			e = alt->endpoint + ep;
+
+			/* ignore endpoints which cannot transfer data */
+			if (!usb_endpoint_maxp(&e->desc))
+				continue;
+
 			switch (e->desc.bmAttributes) {
 			case USB_ENDPOINT_XFER_INT:
 				if (!usb_endpoint_dir_in(&e->desc))


