Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28243EDCE2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 20:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhHPSK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 14:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhHPSKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 14:10:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E924C0612E7
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:42 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lo4so33255392ejb.7
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NFp8ItiruJnih8e9B4NvO8TxjUv+6GZH4k3SEINJRWk=;
        b=E1InZ1hal7yp02RIrwVVQjsdGWFrPpLbbs2F7t3WAdWY1X9p3HMjfAXGSmw4peYrPc
         hn5ACP1mNRr6UqSHEav6ZuaV7j9Sp9qjLVZ0BPsX5CoUdTcsoKlUtl4tCGaA4lypA7J/
         QfpbRzbsFrrHNEoUHXFQbbTmys9d10Cx2bNOdxTy8MhVZZV4iZuKnk1r1mN+8ZWVHUeI
         5ali6tx0mWL0IZmq9Y7FkxWu7x5TnvhqOwT+FQ8YqHFlyaHAo9Yu+jSqxOhaKAmTIVVV
         j+sGFEZ8qZIqDtMa6gIvtoxoIerL6rDMO7rAugqRs6aTQ+G6HWKwd3VZ3Jd3kWPAk8Eg
         DiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NFp8ItiruJnih8e9B4NvO8TxjUv+6GZH4k3SEINJRWk=;
        b=UJwxjDd90c/LtAqTDxsJmEk8eX6F0/S7B3ldB68CVRgl1ldfgRFIbnJEY+SjqLDdMF
         snpvDXTmqUTEqylOj6foXWpnW8vkRHw+Nw9MTnU5/bPTxrucGF10Fv8sSbrYcmvbL6y2
         O4Ge0XvEB+pWnrk8ql45PUypw9FSO+O7Gyc/XrDIXO4nexf+7cwXR0R+mRZwyXTxoYph
         72NnEo05o3dbsVLFTq1JLBBuzQx/7rp8J0ndayyMmxYEVwLm3HB3+hpVUbCfYPSPqdJ/
         HkyWHQ4wKGhxY+Jn2DlPhr9ZkU6hJCZuukmBpuXGS1hFd6iMW+7x+IXsYtMxQrt24Glw
         rdJw==
X-Gm-Message-State: AOAM5336XkVe4CyHbJIy1monRgAsMt9K5vkQAoog+zhKVsHN4LvPlOtA
        91lfs8ogOTm9rkpS/atviJGZLQ==
X-Google-Smtp-Source: ABdhPJyd6Icy7JkcnIET+jJmCfJJVeWWnPGZJHWOUFGzYh0WiS8FCkv7jqnD53UJkM7z99h59bPGRw==
X-Received: by 2002:a17:906:6847:: with SMTP id a7mr8949015ejs.288.1629137380678;
        Mon, 16 Aug 2021 11:09:40 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id t17sm5180003edw.13.2021.08.16.11.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 11:09:40 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:09:38 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 4/5] net: dsa: microchip: ksz8795: Fix VLAN untagged
 flag change on deletion
Message-ID: <20210816180938.GH18930@cephalopod>
References: <20210816174905.GD18930@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816174905.GD18930@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit af01754f9e3c553a2ee63b4693c79a3956e230ab upstream.

When a VLAN is deleted from a port, the flags in struct
switchdev_obj_port_vlan are always 0.  ksz8_port_vlan_del() copies the
BRIDGE_VLAN_INFO_UNTAGGED flag to the port's Tag Removal flag, and
therefore always clears it.

In case there are multiple VLANs configured as untagged on this port -
which seems useless, but is allowed - deleting one of them changes the
remaining VLANs to be tagged.

It's only ever necessary to change this flag when a VLAN is added to
the port, so leave it unchanged in ksz8_port_vlan_del().

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backport to 5.10: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b4b164d75520..8f2b54ae57f2 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -895,7 +895,6 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan)
 {
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
 	u16 data, vid, pvid;
 	u8 fid, member, valid;
@@ -904,8 +903,6 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
 	pvid = pvid & 0xFFF;
 
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
-
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		ksz8795_r_vlan_table(dev, vid, &data);
 		ksz8795_from_vlan(data, &fid, &member, &valid);
-- 
2.20.1

