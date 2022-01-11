Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEE748B5D6
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbiAKSkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiAKSkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:40:17 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [IPv6:2a01:e0c:1:1599::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5C8C06173F;
        Tue, 11 Jan 2022 10:40:17 -0800 (PST)
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id ADCA4B0055E;
        Tue, 11 Jan 2022 19:40:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GZHDE+tkw+MDyyPUgsdYrXngbet9DZMOwhvR8HVv7QQ=; b=S4Apb2/fgGiUJZ3pcP5s8o/bFI
        FZzkLYMMN/PVSM5aRNuaVExjdH1Ac0S403qVGJHC1nGHSBUCDMUFjIYWMo9EneXiwYR0dh4Ks7j8i
        m+/1QgUhWJAisNJUDjXyx6pPSu33hrXHPVg0EkuOmKLhEQ6Akj2Kur5F/WpYEThkp4TQ=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1n7M46-00AULD-0a; Tue, 11 Jan 2022 19:40:14 +0100
Date:   Tue, 11 Jan 2022 19:40:13 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     linux-raid@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, guoqing.jiang@linux.dev,
        artur.paszkiewicz@intel.com
Subject: [md] Missing revert in 5.10
Message-ID: <Yd3PDbLH4v5Ea682@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

41d2d848e5c0 ("md: improve io stats accounting") was added during the
5.9 cycle and therefore is present in the 5.10 branch. This patch was
then reverted in mainline during the 5.14 cycle (ad3fc798800f) due to
report of double faults [1].

However the revert was not picked up for the 5.10 branch. I believe it
should be queued up.

Unfortunately, 41d2d848e5c0 in 5.10 cannot be reverted cleanly because
of the later changes in 00fe60eae94. The mainline 5.14 revert commit
also does not apply cleanly on 5.10 because 99dfc43ecbf6 is not in 5.10.
Manually merging the revert is trivial though (I could provide the patch
I've been testing if that's helpful).

Guillaume.

[1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t

-- 
Guillaume Morin <guillaume@morinfr.org>
