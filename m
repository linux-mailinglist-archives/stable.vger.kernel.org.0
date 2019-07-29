Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E0C78FA1
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387764AbfG2Pmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:42:50 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33569 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387476AbfG2Pmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 11:42:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id f20so19227338pgj.0;
        Mon, 29 Jul 2019 08:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=RKPiZTA2YoR1sZpm3S5fEClBL2fssDBfiWiIIOCDRxM=;
        b=V5aS9kIfli8N1iRiW1c5Z4dJgi3/TlhcKgHQiCs7lIQkVmIqiSH7aLA+PNWLVCg/An
         6+dEL1fMsTZWcioQXS9lcZiIGNMBYdHmjgUXqcg4Ey/tZl+Yr6INdcWfm5aDIlSVcUq9
         Kn/A6UFIOq/FSeE/o56RYafImE473JHxRfMujNAXpPG0waoZAV1/vS7i5MN4J0wu7ofY
         epXeJ8veVcU8oDVqfOzjU3DaLNUE6mmV7ty5dHiOh35PoIYJKGkziSu2Y2RgLfn33GwN
         hYIrr6fuOsCY0198QHyPtN4Qd5d8RYKthE3IfNuWzwNG1wJTs0cBgwmV62CqcDrxhLrn
         Ys2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=RKPiZTA2YoR1sZpm3S5fEClBL2fssDBfiWiIIOCDRxM=;
        b=LWAdYKyE+lKDTEp4IxinSPOV4uVrIu5AYNdcsAqsrGqsofN6rldKEBlUJnR3TubEpf
         nE4LFHYbduMYJuur87PBgvbuWvEfvWAv3jhrdayr9ZnlQuW/lbdylvBkv2c6fwMelcBM
         1Xl4yY2eN9eTdKm27Qe8mse6bEzi7FsQ2+XlzZ5Wp47oBr5oW3Cs6j1ufKp0IaAP86pQ
         5+cHLgJQTYDBuZ5kOu5wwkBlqji3djqftU69VRQ5G4KqRvCQMRbFL0U+SSqLKCTe90vo
         oWobTFQVaMdB3+CG11100MFxJwH9/wVvbKS5t1R6cnicyL73jYlUCn+gxDBuU3v8Gh0n
         s5Ng==
X-Gm-Message-State: APjAAAVP/qCiJ8D+HXZEyN8EBMZFnTPEvwVdlctgmupZKm3l/2MPxsRM
        YrDSlS2d6oPLyxha49BUIsGTKUs=
X-Google-Smtp-Source: APXvYqzICHrByfUpJ4Ded36rYhJTzRwCNRoZYuwNwUGbIJE6p67/Ot9qOM53rWX8GL++lFphVRnNvA==
X-Received: by 2002:a65:5c4b:: with SMTP id v11mr62285172pgr.62.1564414968814;
        Mon, 29 Jul 2019 08:42:48 -0700 (PDT)
Received: from ubuntu ([12.38.14.9])
        by smtp.gmail.com with ESMTPSA id r75sm84439798pfc.18.2019.07.29.08.42.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 08:42:48 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:42:34 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, greg@kroah.com, dsahern@gmail.com,
        davem@davemloft.net
Subject: Back-porting request
Message-ID: <20190729154234.GA3508@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I'm requesting this commit to be back-ported to v4.14:
---
commit 5b18f1289808fee5d04a7e6ecf200189f41a4db6
Author: Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Wed Jun 26 02:21:16 2019 -0400

    ipv4: reset rt_iif for recirculated mcast/bcast out pkts

    Multicast or broadcast egress packets have rt_iif set to the oif. These
    packets might be recirculated back as input and lookup to the raw
    sockets may fail because they are bound to the incoming interface
    (skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
    returns rt_iif instead of skb_iif. Hence, the lookup fails.

    v2: Make it non vrf specific (David Ahern). Reword the changelog to
        reflect it.
    Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
    Reviewed-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
---

We found the issue in that release and the above commit is on
linux-stable. On the discussion behind this commit, please see:
https://www.spinics.net/lists/netdev/msg581045.html

I think after the following diff is needed on top of the above commit
for v4.14:

---
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 4d85a4fdfdb0..ad2718c1624e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1623,11 +1623,8 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 		new_rt->rt_iif = rt->rt_iif;
 		new_rt->rt_pmtu = rt->rt_pmtu;
 		new_rt->rt_mtu_locked = rt->rt_mtu_locked;
-		new_rt->rt_gw_family = rt->rt_gw_family;
-		if (rt->rt_gw_family == AF_INET)
-			new_rt->rt_gw4 = rt->rt_gw4;
-		else if (rt->rt_gw_family == AF_INET6)
-			new_rt->rt_gw6 = rt->rt_gw6;
+		new_rt->rt_gateway = rt->rt_gateway;
+		new_rt->rt_table_id = rt->rt_table_id;
 		INIT_LIST_HEAD(&new_rt->rt_uncached);
 
 		new_rt->dst.flags |= DST_HOST;
---

Thank you,

Stephen.
