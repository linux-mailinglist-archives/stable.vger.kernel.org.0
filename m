Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988193EDCDF
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 20:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhHPSK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbhHPSKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 14:10:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F165AC0612A6
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d6so27777072edt.7
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zj9DtZNu3Q5lzcO5ya/7HcU4ots3BHO7m+UZEwEjOK0=;
        b=P3od03FJR7TCIir+ZWZ9KFRvdy627Sj59JznVxQNEjZa6DAEwzLat+vf7fsL9PQ1VN
         g82QHQo0uSEd2nbyoaIaxq8SAMKn8nJp/9mDdE23HWEkokYeLfS1EAFeC4XsI+YBsGQm
         bdz+8X1RiY5vA2SuWJO820nQ6wVY+quykzw4wbtATB2lFSv3wOaYmCB64y32DnVxYTyj
         +Yw7iIY9HT7ib4OE0zs6dZuDKpzCK1WvFDB97AvvzSLKCvm3M3aT9+Y3NNGYx1GymQ6O
         KqW6EJkyU0eHqPSNpEQ9PpRj159vYQ9NzfqoszO0ccVvSD+3V6Dz5I3Z78tqRA7vfOsy
         yRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zj9DtZNu3Q5lzcO5ya/7HcU4ots3BHO7m+UZEwEjOK0=;
        b=cDY6R8qKiKeVS7AUXJXoQN1XX97pOwIZxYTU2ciZ0kmTyLanT6WkCrfmhfFKyFYu0s
         XreqZ5+47BjZBYj8JuWucQZEISZFD50W7fNW5rZCnkMuw2spKaA9bmPXwQLopVBHvd5Y
         AlcxNxrsbAb86D2EXQdlYLmPUBklax9PATBCO2HfU+yAUkbsIWjqdosLvmfJ2cuKJwlp
         T1Iyr6OsJNp8not+jp2Du7lABAIwSHfLeQ55XVQgkhPJ1XVIxNaGheqnWflo9M2tOaLS
         nJ1RWRdXr8/W+PmXRanxPBfPRHzbDK5Hoxw/tqYBJO7AJGSLa/EUMLafbN9vC2egjJEw
         c7lA==
X-Gm-Message-State: AOAM531G9/pyxFOxlQ/EbRA3810lSjmzIU8a+uc+ryEi71VCPhuhGhcj
        INIqJGn2BDnuWpio8AN2sx90hw==
X-Google-Smtp-Source: ABdhPJyu91YcIG5W9sZ9ALo4QBALyweoiLRGGYmbZVc/12XWHfdEMc8XMzaOyCZdbTrBKUIiFGiDqw==
X-Received: by 2002:aa7:d681:: with SMTP id d1mr22359818edr.186.1629137387595;
        Mon, 16 Aug 2021 11:09:47 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id bm1sm3989649ejb.38.2021.08.16.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 11:09:47 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:09:45 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 5/5] net: dsa: microchip: ksz8795: Use software
 untagging on CPU port
Message-ID: <20210816180945.GI18930@cephalopod>
References: <20210816174905.GD18930@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816174905.GD18930@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9130c2d30c17846287b803a9803106318cbe5266 upstream.

On the CPU port, we can support both tagged and untagged VLANs at the
same time by doing any necessary untagging in software rather than
hardware.  To enable that, keep the CPU port's Remove Tag flag cleared
and set the dsa_switch::untag_bridge_pvid flag.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backport to 5.10: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8f2b54ae57f2..ada0533b81fa 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -812,9 +812,11 @@ static bool ksz8795_port_vlan_changes_remove_tag(
 	/* If a VLAN is added with untagged flag different from the
 	 * port's Remove Tag flag, we need to change the latter.
 	 * Ignore VID 0, which is always untagged.
+	 * Ignore CPU port, which will always be tagged.
 	 */
 	return untagged != p->remove_tag &&
-		!(vlan->vid_begin == 0 && vlan->vid_end == 0);
+		!(vlan->vid_begin == 0 && vlan->vid_end == 0) &&
+		port != dev->cpu_port;
 }
 
 int ksz8795_port_vlan_prepare(struct dsa_switch *ds, int port,
@@ -1325,6 +1327,11 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt + 1;
 
+	/* We rely on software untagging on the CPU port, so that we
+	 * can support both tagged and untagged VLANs
+	 */
+	dev->ds->untag_bridge_pvid = true;
+
 	/* VLAN filtering is partly controlled by the global VLAN
 	 * Enable flag
 	 */
-- 
2.20.1
