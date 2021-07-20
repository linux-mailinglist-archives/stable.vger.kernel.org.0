Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDA03D02C2
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhGTTb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbhGTTaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:30:07 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD87C061762
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 13:10:44 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso2170990wmh.4
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 13:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jakma-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version;
        bh=ujpcn5xxbqKrLHJ8YgF2WLu43nbvYoHOnJdrAYEpQQM=;
        b=x6o4hLvBjsk6d1FsJXb1rVZElaXMb6sOmmKe/ym5NXIDhJlihVDacDgdsP2Uy/JTUG
         Unf+8hh5YEuoz6YabvMyehZYKLApn8jOsZJBaW4T78wrPXl5o2GD2wovZ+av5RFc5Sc4
         uPhRmjjB/zD/owemRSYR2ykyYjart+tARWfbX5CD+pchQ8qce1wZt+jrzn6a8ssy84zd
         mv59GQPYmTqiSDkh/FQpy+TK1/x3msx0SO+Q0X72I287J04wUDuanZOjqPZtHTo490Qe
         FjEI1h/u6iN2cKiuaLgdAwbe4boSO4vpNqBpnvdlOylWeXQqwaXLJTdHx/hYj5+eWEi1
         L1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version;
        bh=ujpcn5xxbqKrLHJ8YgF2WLu43nbvYoHOnJdrAYEpQQM=;
        b=CqLyR526s2v6RNPRamvKtS2KVVGPLWyhjzFL2DdakXsi8bh/0ZZ0EfA9RNxwLkE7cF
         STZ8axd32oyT5pUxvW9+HSC8X7KHFZGZhcKno0dtBfWKIdSFmVr1OKu9Roa7OafjQ3ka
         n74vvjBF47K1fz+53icmGD+C/jpPPBNOn3Ndox2kR62UoGwcGV/h+BcSYEmoOWo/4MWl
         IYDYA+ubSDuqxjwrqOzjC4WG0voEE6Kgp9BJzGtXLd11rr1f0+09iLQQ/poW5lHC/DDZ
         LeV6pD9NsU19yQO7yAdP1LcEwNlGoTOouJtzf2B5WZ79vxAwzezLIUGGhG1Fm1O0RqvK
         6/LA==
X-Gm-Message-State: AOAM533hs7n+nW3V9ak7a4WQaTEQSaLCTPo3gs2dGAm0tgjI/Vl3HktS
        NCLT6AAEdpbtk2N/j7EypjyQJg==
X-Google-Smtp-Source: ABdhPJwt/LOTIwAERnRJYlrINSgEPJmfuzoV4romOusCIQD5auVitI9ZtFYxwdCovVvYzfPlDiTXFQ==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr33055501wmb.39.1626811843185;
        Tue, 20 Jul 2021 13:10:43 -0700 (PDT)
Received: from sagan.jakma.org ([2a01:ac:1000:100::ab])
        by smtp.gmail.com with ESMTPSA id y11sm3432161wmi.33.2021.07.20.13.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:10:42 -0700 (PDT)
Date:   Tue, 20 Jul 2021 21:10:37 +0100 (BST)
From:   Paul Jakma <paul@jakma.org>
To:     davem@davemloft.net
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, stable <stable@vger.kernel.org>,
        Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] NIU: fix missing revert of return and fix the driver
Message-ID: <70d84870-2d7a-77b2-175b-ef1ff3cb6c38@jakma.org>
X-Snooper: A life spent reading others private email is a sad and wasted one
X-NSA:  nitrate toxic DNDO hostage al aqsar fluffy jihad DHS cute musharef kittens jet-A1 ear avgas wax ammonium bad qran dog inshallah allah al-akbar martyr iraq hammas hisballah rabin ayatollah korea revolt mustard gas x-ray british airways hydrogen washington peroxide cool FEMA emergency four lions encryption ricin table pandemic scanner power sleet catalyst injection acetone toluene amatol
X-KEYSCORE: The greatest long-term threats to freedom and democracy are based in Langley and Fort Meade and Cheltenham
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The revert of commit 26fd962 missed out on reverting an incorrect change 
to a return value. The niu_pci_vpd_scan_props(..) == 1 case appears to 
be a normal path - treating it as an error and return -EINVAL was 
breaking VPD_SCAN and causing the driver to fail to load.

Fix it, so my Neptune card works again.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Shannon Nelson <shannon.lee.nelson@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 7930742d ('Revert "niu: fix missing checks of niu_pci_eeprom_read"')
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Paul Jakma <paul@jakma.org>
---

--- e6e337708c22f80824b82d4af645f20715730ad0/drivers/net/ethernet/sun/niu.c	2021-07-20 20:51:52.054770659 +0100
+++ fix/drivers/net/ethernet/sun/niu.c	2021-07-20 20:49:02.194870695 +0100
@@ -8192,7 +8192,7 @@
  		if (err < 0)
  			return err;
  		if (err == 1)
-			return -EINVAL;
+			return 0;
  	}
  	return 0;
  }
-- 
Paul Jakma | paul@jakma.org | @pjakma | Key ID: 0xD86BF79464A2FF6A
Fortune:
How sharper than a serpent's tooth is a sister's "See?"
 		-- Linus Van Pelt
