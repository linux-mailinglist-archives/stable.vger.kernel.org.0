Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5533E8221
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhHJSFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238325AbhHJSEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896C861269;
        Tue, 10 Aug 2021 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617698;
        bh=/46Isby7duy4DJFKRgE0tr3rOUSRkc/d1UFq+B3pQ68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bUIkW+H5R2r2BcePEgfFBtwQicll1ii2zsbwKUaas1N1RyOoAQ1TOWOVnOkq2H7F
         dDL44uXXi4/aODoLDfXiUyRtmv01y3785AQLwG40ffHd/pp66h/JiUbht2ElgWIvq6
         H3EhlupAjMQ1tTJKgvgRFsj+7TTUxMHc4CUxQNVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.13 140/175] bus: ti-sysc: AM3: RNG is GP only
Date:   Tue, 10 Aug 2021 19:30:48 +0200
Message-Id: <20210810173005.551298962@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hilman <khilman@baylibre.com>

commit a6d90e9f22328f07343e49e08a4ca483ae8e8abb upstream.

Make the RNG on AM3 GP only.

Based on this patch from TI v5.4 tree which is based on hwmod data
which are now removed:

| ARM: AM43xx: hwmod: Move RNG to a GP only links table
|
| On non-GP devices the RNG is controlled by the secure-side software,
| like in DRA7xx hwmod we should not control this IP when we are not
| a GP device.
|
| Signed-off-by: Andrew F. Davis <afd@ti.com>

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/ti-sysc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2953,6 +2953,8 @@ static int sysc_init_soc(struct sysc *dd
 		case SOC_3430 ... SOC_3630:
 			sysc_add_disabled(0x48304000);	/* timer12 */
 			break;
+		case SOC_AM3:
+			sysc_add_disabled(0x48310000);  /* rng */
 		default:
 			break;
 		}


