Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42C7356CCA
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352516AbhDGNAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:00:40 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:37574 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhDGNAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 09:00:39 -0400
Received: by mail-wr1-f53.google.com with SMTP id u11so5456128wrp.4;
        Wed, 07 Apr 2021 06:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NwLKTNKDKP75b7p50B/o71iDiFr0JTQFhm3wPogEFdU=;
        b=uZc1CazioGqDDGzGCDI/kQr2FLSJ+clYEQ85NDTpaTtJ9LTkTeMc2kiOZ6wdebpnii
         LSoJKiPRbMQUDv5hcCBuCHqQTuAMpCRzY/IEYs+Fs03ZOUxxNfZbFiOeC1EiZysMslrS
         +yEBhxJja1siX4XqrwJt2uGOW8PWgrnkIuOGd0+vEQoIHuOtaL2UE4CrY0xUjVa/jD+I
         //SOYsB5MIvNziNlPk5xlcJvoZPRY7G5sBONIAcS+OeMCUttcgtRFfWQblQCfO648AFo
         dL1FaIx6lpD/x9MhKEtufPn80QVnDmtp8JLmxWoR7+RWiNBFhbW7eTBw3gg/F9XrnctE
         WPlA==
X-Gm-Message-State: AOAM531HNNibMTEByaVRxXsqT2vvSfotodaTAzAzf1xrksynCYaxzCub
        /0bh1KFTfzBC08uFNuN09PQ=
X-Google-Smtp-Source: ABdhPJze8GqaoC7VT4EBUo/P3ST9s9tLdsZXJdoXUKWyW/Gkw8UQr9VDY3nhMuQID9gqjD7B0tz1BA==
X-Received: by 2002:a05:6000:2a7:: with SMTP id l7mr3338450wry.413.1617800427739;
        Wed, 07 Apr 2021 06:00:27 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id k3sm19834667wrc.67.2021.04.07.06.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 06:00:26 -0700 (PDT)
Date:   Wed, 7 Apr 2021 13:00:25 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Luca Fancellu <luca.fancellu@arm.com>
Cc:     sstabellini@kernel.org, jgross@suse.com, jgrall@amazon.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, wei.liu@kernel.org,
        jbeulich@suse.com, yyankovskyi@gmail.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, bertrand.marquis@arm.com
Subject: Re: [PATCH] xen/evtchn: Change irq_info lock to raw_spinlock_t
Message-ID: <20210407130025.tfe6aszjyjzz6ar2@liuwe-devbox-debian-v2>
References: <20210406105105.10141-1-luca.fancellu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406105105.10141-1-luca.fancellu@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 11:51:04AM +0100, Luca Fancellu wrote:
> Unmask operation must be called with interrupt disabled,
> on preempt_rt spin_lock_irqsave/spin_unlock_irqrestore
> don't disable/enable interrupts, so use raw_* implementation
> and change lock variable in struct irq_info from spinlock_t
> to raw_spinlock_t
> 
> Cc: stable@vger.kernel.org
> Fixes: 25da4618af24 ("xen/events: don't unmask an event channel
> when an eoi is pending")
> 
> Signed-off-by: Luca Fancellu <luca.fancellu@arm.com>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
