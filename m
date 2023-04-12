Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49AD6DF63E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 14:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDLM4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 08:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDLM4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 08:56:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDFA1FFC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 05:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 226F76348A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87350C4339B;
        Wed, 12 Apr 2023 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681304140;
        bh=iqZBaeODnGbLrHrbvxwREeRqtMd+mKJxt4Zldqs66qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/fnsVbMy/BsAzyk+/kxyyMLhPADjsOGWk7cmDo0nQbn7rOL0fP6BjUXIZ71JtM8L
         2vOKPRYCP3cm1gEdI1UoUUHAyaxWcZ60eKHOuFz/mlX0/gmSoD2BedwfKdQu0CgIdJ
         uD7qs8iDDlmrw8taGXBAD8ptGNgSWTcOeI/+ZKvqIgemrKJPElgGpD+Lh5WIvBVWak
         vOt/OhJ0SKu7YUFS1Rt+Acd2h17XdUuGJnizV+JeZALSfAMWIXGt1GifMs+PNsK3IT
         2/13VC2FR6vJs2kRbItet3d9vT4oM4tXm5CUJn5ipVWbh72x9KO6TtQNRP/i6h8fPc
         sZPRO2cj+kQkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pma0g-007q0n-G8;
        Wed, 12 Apr 2023 13:55:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Don't acquire its_lock before config_lock
Date:   Wed, 12 Apr 2023 13:55:35 +0100
Message-Id: <168130412864.78725.7707238818559974772.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412062733.988229-1-oliver.upton@linux.dev>
References: <20230412062733.988229-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, stable@vger.kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 Apr 2023 06:27:33 +0000, Oliver Upton wrote:
> commit f00327731131 ("KVM: arm64: Use config_lock to protect vgic
> state") was meant to rectify a longstanding lock ordering issue in KVM
> where the kvm->lock is taken while holding vcpu->mutex. As it so
> happens, the aforementioned commit introduced yet another locking issue
> by acquiring the its_lock before acquiring the config lock.
> 
> This is obviously wrong, especially considering that the lock ordering
> is well documented in vgic.c. Reshuffle the locks once more to take the
> config_lock before the its_lock. While at it, sprinkle in the lockdep
> hinting that has become popular as of late to keep lockdep apprised of
> our ordering.

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Don't acquire its_lock before config_lock
      commit: 49e5d16b6fc003407a33a9961b4bcbb970bd1c76

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


