Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C616C97A2
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjCZTeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 15:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZTen (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 15:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A306449E6;
        Sun, 26 Mar 2023 12:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AC0760ECB;
        Sun, 26 Mar 2023 19:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8E5C433D2;
        Sun, 26 Mar 2023 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679859279;
        bh=GidJKYIOLmvfz4aB/GwhhYhvXHg30d4L87WaccShj0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhEGBET99VkJodmP+8qQRBHYJ0gnbGFiAzKvHIWfXt4zsogzzY+CFizrzU44Ih6+n
         rT5fuQwYM+89Ms9v5uCcL0di/veqyw7LbSM4WRvWVC1mjcqSR/ntmexyIdQVI7MFSN
         WQIziWdI5nva5bPTQcS96T5K0RlvSEQbYmJ2ioVXupEtubh9zREDYcFlCHzznU3dwX
         39pKh1V+3UPt5dNvbP20tGgcRQokJ+AIJCnjFwnD4dvqyDd7fd3u4nPEykfvpINsnd
         6lBAK/0GDLy/dGMw2arzCt6KW4nyiDfgjmx8z5BDeHZZzJN44Akd1Rj8bB1cLPJ2mb
         uHUXh68B6VnaQ==
Date:   Sun, 26 Mar 2023 21:34:35 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] tick/nohz: Fix cpu_is_hotpluggable() by
 checking with nohz subsystem
Message-ID: <ZCCeS/VeGthUNgIY@localhost.localdomain>
References: <20230325173316.3118674-1-joel@joelfernandes.org>
 <20230325173316.3118674-5-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230325173316.3118674-5-joel@joelfernandes.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le Sat, Mar 25, 2023 at 05:33:07PM +0000, Joel Fernandes (Google) a écrit :
> For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> torture tests that do offlining to end up trying to offline this CPU causing
> test failures. Such failure happens on all architectures.

It might be worth noting that hotplug failure is fine on hotplug testing.
The issue here is the repetitive error message in the logs.

Other than that:

Acked-by: Frederic Weisbecker <frederic@kernel.org>
