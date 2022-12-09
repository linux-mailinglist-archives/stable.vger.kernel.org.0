Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4A6481FB
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 12:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLILyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 06:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLILyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 06:54:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4510A2F644;
        Fri,  9 Dec 2022 03:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670586840; x=1702122840;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=i6l99AsOk7Ek/fC/JJlzKRTZl8kQmivMJCaJu9pD6WY=;
  b=g70OOyfpq57JmzL5fNoWYyVwu5sApRbF+H0X/Ja0tg51Gqeitl7PkDK+
   dPsM1QjjjEuUlOzBjtpONK4QD4hcPZ+7kjVu3X84kpkXbQJNXSpEXPzGg
   9Q+KrqrDZjZRR0gxgaUhVa+zcyJ4RLhNLD/m1K+9RzxoZvhzgBtw7zZDV
   f58WPBIFy1KzO0bnf7YrZqlfpRSbezkRCAKcSHtGizkYo7j7i8rZuuhfM
   CteNhoMvf5Is2mjhWkT6NXmoA0Cmk5+lsUyLwmAX88bTkNQ42B6NEBkCQ
   oP6Mbg34Q4Vbn+jocPCpol7WK+fKDW4Y9Xuek6DIPJjddXOPYYyjPOLUT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="305085941"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="305085941"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 03:53:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="736191278"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="736191278"
Received: from eliteleevi.tm.intel.com ([10.237.54.20])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 03:53:50 -0800
Date:   Fri, 9 Dec 2022 13:53:31 +0200 (EET)
From:   Kai Vehmanen <kai.vehmanen@linux.intel.com>
X-X-Sender: kvehmane@eliteleevi.tm.intel.com
To:     Ricardo Ribalda <ribalda@chromium.org>
cc:     Oliver Neukum <oneukum@suse.com>, Juergen Gross <jgross@suse.com>,
        Mark Brown <broonie@kernel.org>,
        Chromeos Kdump <chromeos-kdump@google.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Len Brown <len.brown@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biederman <ebiederm@xmission.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Joel Fernandes <joel@joelfernandes.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Takashi Iwai <tiwai@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        kexec@lists.infradead.org,
        Alsa-devel <alsa-devel@alsa-project.org>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v8 3/3] ASoC: SOF: Fix deadlock when shutdown a frozen
 userspace
In-Reply-To: <CANiDSCtm7dCst_atiWk=ZcK_D3=VzvD0+kWXVQr4gEn--JjGkw@mail.gmail.com>
Message-ID: <alpine.DEB.2.22.394.2212091349310.3532114@eliteleevi.tm.intel.com>
References: <20221127-snd-freeze-v8-0-3bc02d09f2ce@chromium.org> <20221127-snd-freeze-v8-3-3bc02d09f2ce@chromium.org> <716e5175-7a44-7ae8-b6bb-10d9807552e6@suse.com> <CANiDSCtwSb50sjn5tM7jJ6W2UpeKzpuzng+RdJuywiC3-j2zdg@mail.gmail.com>
 <d3730d1d-6f92-700a-06c4-0e0a35e270b0@suse.com> <CANiDSCtm7dCst_atiWk=ZcK_D3=VzvD0+kWXVQr4gEn--JjGkw@mail.gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7 02160 Espoo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, 1 Dec 2022, Ricardo Ribalda wrote:

> On Thu, 1 Dec 2022 at 14:22, 'Oliver Neukum' via Chromeos Kdump <chromeos-kdump@google.com> wrote:
> >
> > On 01.12.22 14:03, Ricardo Ribalda wrote:
> > > This patchset does not modify this behaviour. It simply fixes the
> > > stall for kexec().
> > >
> > > The  patch that introduced the stall:
> > > 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers
> > > in .shutdown")
> >
> > That patch is problematic. I would go as far as saying that
> > it needs to be reverted.
> 
> It fixes a real issue. We have not had any complaints until we tried
> to kexec in the platform.
> I wont recommend reverting it until we have an alternative implementation.
> 
> kexec is far less common than suspend/reboot.

I've posted an alternative to ALSA list that reverts the problematic
patch and fixes the problem (the patch was originally addressing)
in a different way:

https://mailman.alsa-project.org/pipermail/alsa-devel/2022-December/209776.html

No changes outside sound/soc/ are needed with this approach.

Br, Kai
