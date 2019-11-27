Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DD810BD70
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfK0V2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:28:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:52526 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfK0U6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:06 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 12:58:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="211805140"
Received: from gtau-mobl.ger.corp.intel.com (HELO localhost) ([10.251.83.243])
  by orsmga003.jf.intel.com with ESMTP; 27 Nov 2019 12:58:02 -0800
Date:   Wed, 27 Nov 2019 22:58:00 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org, James Morris <jmorris@namei.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tpmdd updates for Linux v5.4
Message-ID: <20191127205800.GA14290@linux.intel.com>
References: <20190902143121.pjnykevzlajlcrh6@linux.intel.com>
 <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmeLnHK4y+usQaWo72nUG3RNsripuZnS-koY4XTRC+mwJA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 08:48:25PM -0800, Dan Williams wrote:
> On Mon, Sep 2, 2019 at 7:34 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Hi
> >
> > A new driver for fTPM living inside ARM TEE was added this round. In
> > addition to that, there is three bug fixes and one clean up.
> >
> > /Jarkko
> >
> > The following changes since commit 8fb8e9e46261e0117cb3cffb6dd8bb7e08f8649b:
> >
> >   Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma (2019-08-30 09:23:45 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20190902
> >
> > for you to fetch changes up to e8bd417aab0c72bfb54465596b16085702ba0405:
> >
> >   tpm/tpm_ftpm_tee: Document fTPM TEE driver (2019-09-02 17:08:35 +0300)
> >
> > ----------------------------------------------------------------
> > tpmdd updates for Linux v5.4
> >
> > ----------------------------------------------------------------
> > Jarkko Sakkinen (1):
> >       tpm: Remove a deprecated comments about implicit sysfs locking
> >
> > Lukas Bulwahn (1):
> >       MAINTAINERS: fix style in KEYS-TRUSTED entry
> >
> > Sasha Levin (2):
> >       tpm/tpm_ftpm_tee: A driver for firmware TPM running inside TEE
> >       tpm/tpm_ftpm_tee: Document fTPM TEE driver
> >
> > Stefan Berger (2):
> >       tpm_tis_core: Turn on the TPM before probing IRQ's
> >       tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
> 
> Hi Jarrko,
> 
> I'm replying here because I can't find the patches to reply to
> directly from LKML.
> 
> Commit 7f064c378e2c "tpm_tis_core: Turn on the TPM before probing
> IRQ's" in the v5.3-stable tree caused a regression on a pre-release
> platform with a TPM2 device. The interrupt starts screaming when the
> driver is loaded and does not stop until the device is force unbond
> from the driver by:
> 
>      echo IFX0740:00 > /sys/bus/platform/drivers/tpm_tis/unbind
> 
> I checked v5.4-rc8 and it has the same problem. I tried reverting:
> 
> 1ea32c83c699 tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts
> 5b359c7c4372 tpm_tis_core: Turn on the TPM before probing IRQ's
> 
> Which silenced the screaming interrupt problem, but now the TPM is reporting:
> 
> [    3.725131] tpm_tis IFX0740:00: 2.0 TPM (device-id 0x1B, rev-id 16)
> [    3.725358] tpm tpm0: tpm_try_transmit: send(): error -5
> [    3.725359] tpm tpm0: [Firmware Bug]: TPM interrupt not working,
> polling instead
> 
> ...at load, where it was not reporting this previously. Can you take a look?

It is already in WiP:

https://patchwork.kernel.org/patch/11240111/

Stefan also sent patches that revert to changes that you described:

https://patchwork.kernel.org/cover/11262363/

Probably better first to fix the issue on top of master before deciding
actions.

/Jarkko
