Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F773EDCD6
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhHPSJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 14:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhHPSJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 14:09:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FC0C0613C1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n12so27764688edx.8
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O3ErUZ22t3/2NnJvS4t3GxIKREc/lpK4t3GrCBcKr0s=;
        b=MqIR+wT3TQ7AperC/QwCBgWjfTLvLSef5OV3AlZZPKb99x1zp9VkDperrxeByexvZo
         6btdJ3JlSZoWgdIJZtALiWD/7fEXImETrT+PY1kmGFHHGIUUBzmrWfJj7JbwjWQkwhy/
         tw1ufFGwyjPpT3FZNhYPIP/bpOJTFHrV5HjvtrH9CII5KLn37RhUYIHH3hh5AmSBE6Tm
         F8yakd5pZDW8Q9UA7HGQtOWOG9bU8Db8/Pfmg4tUFoPhEghY+QeG92EOSzMPd6hCWA1M
         KmYRWIK3TH0S8Qb2Kv2dv+hHupAPnw/bCJrSGrbsCHOjV2xfd7iBRdJwU+BxWiytldxr
         m9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O3ErUZ22t3/2NnJvS4t3GxIKREc/lpK4t3GrCBcKr0s=;
        b=mSRMuz+9xhMhWCrWvbnrOosEdqzgMeQO8FRP2kjbzLdie3hMuA4i3st+PInoCX1Q3z
         HR9/x4PgChNJG+snqvQnwB/qfkCqbUrnpwJokvYrSQ/yu8hVMwWB97mufIOvnO+ABDLD
         UHT58AV+MPp7joa6HmvN6jrRxRzGv9ko8zSysSYbGWDR66wgnpb7Wec7LhLBx2IAwUIM
         ib41uJ94GG3ERf533jy36mg5tQDxFJQr/3du7tjspjriYAIK9OZsMbE9Mn0dGZWIfInA
         BY+p/JYonBgif0Y3e+qpwUcqL6WaXPg+tXjbkC9E6/kdb+1i1yjfnwXDqaAYS2UZT+z7
         +BDA==
X-Gm-Message-State: AOAM531SATz/Kjw+UATz7jgivtBT0Ve2sOwr41wsao1f92fjRp2/b1BO
        SEuc20ezozJgJyfD0iPw25nitg==
X-Google-Smtp-Source: ABdhPJxr/NOJQwEcR8v0SouCivf0RaGELa2786Pp80kXXkfyso/2qhYytT5Bic1pg8IR4u20WhzRTQ==
X-Received: by 2002:aa7:cad9:: with SMTP id l25mr22395060edt.351.1629137351869;
        Mon, 16 Aug 2021 11:09:11 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id fl2sm3916189ejc.114.2021.08.16.11.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 11:09:11 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:09:09 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH 5.10 1/5] net: dsa: microchip: Fix probing KSZ87xx switch
 with DT node for host port
Message-ID: <20210816180909.GE18930@cephalopod>
References: <20210816174905.GD18930@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816174905.GD18930@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ksz8795 and ksz9477 drivers differ in the way they count ports.
For ksz8795, ksz_device::port_cnt does not include the host port
whereas for ksz9477 it does.  This inconsistency was fixed in Linux
5.11 by a series of changes, but remains in 5.10-stable.

When probing, the common code treats a port device node with an
address >= dev->port_cnt as a fatal error.  As a minimal fix, change
it to compare again dev->mib_port_cnt.  This is the length of the
dev->ports array that the port number will be used to index, and
always includes the host port.

Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d4a64dbde315..88fa0779e0bc 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -432,7 +432,7 @@ int ksz_switch_register(struct ksz_device *dev,
 				if (of_property_read_u32(port, "reg",
 							 &port_num))
 					continue;
-				if (port_num >= dev->port_cnt)
+				if (port_num >= dev->mib_port_cnt)
 					return -EINVAL;
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
-- 
2.20.1

