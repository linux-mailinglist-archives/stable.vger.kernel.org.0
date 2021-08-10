Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F1E3E80A9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhHJRvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236922AbhHJRtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D9796124E;
        Tue, 10 Aug 2021 17:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617321;
        bh=cegcfvr5IQIrGgLlF/BeWlnuFdLZF8vMezKxmDl7Yp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1H9Yk5rEI5XkfEZcMR63n1eOffzMMzfvj11MV3uGqMZjyJdiAfhrGa41C/z4ni4sc
         wVqvFcOsvvSgSfriup6SpGXLQxugE3DJyB22g03FX5oSemWH8PX8cpMEO0d3mP/yuV
         JI0/bBUB9c0yIPEKnJodz3jzfetxtixJ+Vd3TeqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 106/135] bus: ti-sysc: AM3: RNG is GP only
Date:   Tue, 10 Aug 2021 19:30:40 +0200
Message-Id: <20210810172959.364408559@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -2920,6 +2920,8 @@ static int sysc_init_soc(struct sysc *dd
 		case SOC_3430 ... SOC_3630:
 			sysc_add_disabled(0x48304000);	/* timer12 */
 			break;
+		case SOC_AM3:
+			sysc_add_disabled(0x48310000);  /* rng */
 		default:
 			break;
 		};


