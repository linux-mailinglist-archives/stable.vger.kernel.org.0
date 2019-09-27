Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E68AC0899
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfI0P3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Sep 2019 11:29:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:51055 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfI0P3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Sep 2019 11:29:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 08:29:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="365194486"
Received: from mdauner2-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.39.118])
  by orsmga005.jf.intel.com with ESMTP; 27 Sep 2019 08:29:39 -0700
Date:   Fri, 27 Sep 2019 18:29:38 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] efi+tpm: Don't access event->count when it isn't
 mapped.
Message-ID: <20190927152938.GB10545@linux.intel.com>
References: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
 <CAKv+Gu9xLXWj8e70rs6Oy3aT_+qvemMJqtOETQG+7z==Nf_RcQ@mail.gmail.com>
 <20190925145011.GC23867@linux.intel.com>
 <20190925151616.3glkehdrmuwtosn3@cantor>
 <20190925164133.nmzzhwgagpqvwclu@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925164133.nmzzhwgagpqvwclu@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 09:41:33AM -0700, Jerry Snitselaar wrote:
> On Wed Sep 25 19, Jerry Snitselaar wrote:
> > On Wed Sep 25 19, Jarkko Sakkinen wrote:
> > > On Wed, Sep 25, 2019 at 12:25:05PM +0200, Ard Biesheuvel wrote:
> > > > On Wed, 25 Sep 2019 at 12:16, Jarkko Sakkinen
> > > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > > 
> > > > > From: Peter Jones <pjones@redhat.com>
> > > > > 
> > > > > Some machines generate a lot of event log entries.  When we're
> > > > > iterating over them, the code removes the old mapping and adds a
> > > > > new one, so once we cross the page boundary we're unmapping the page
> > > > > with the count on it.  Hilarity ensues.
> > > > > 
> > > > > This patch keeps the info from the header in local variables so we don't
> > > > > need to access that page again or keep track of if it's mapped.
> > > > > 
> > > > > Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
> > > > > Cc: linux-efi@vger.kernel.org
> > > > > Cc: linux-integrity@vger.kernel.org
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Peter Jones <pjones@redhat.com>
> > > > > Tested-by: Lyude Paul <lyude@redhat.com>
> > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > Acked-by: Matthew Garrett <mjg59@google.com>
> > > > > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > 
> > > > Thanks Jarkko.
> > > > 
> > > > Shall I take these through the EFI tree?
> > > 
> > > Would be great, if you could because I already sent one PR with fixes for
> > > v5.4-rc1 yesterday.
> > > 
> > > /Jarkko
> > 
> > My patch collides with this, so I will submit a v3 that applies on top of
> > these once I've run a test with all 3 applied on this t480s.
> 
> Tested with Peter's patches, and that was the root cause on this 480s.
> 
> I think there should still be a check for tbl_size to make sure we
> aren't sticking -1 into efi_tpm_final_log_size though, which will be
> the case right now if it fails to parse an event.

You could sent a follow up patch for that I think. The current
ones are kind of already "went through the process" and do right
things but I do agree that a sanity check would make sense just
in case.

/Jarkko
