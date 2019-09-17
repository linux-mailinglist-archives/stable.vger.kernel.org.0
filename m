Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8153AB55FB
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 21:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfIQTNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 15:13:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:31049 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfIQTNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 15:13:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 12:13:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,517,1559545200"; 
   d="scan'208";a="198791424"
Received: from vcazacux-wtg.ger.corp.intel.com (HELO localhost) ([10.252.38.72])
  by orsmga002.jf.intel.com with ESMTP; 17 Sep 2019 12:13:09 -0700
Date:   Tue, 17 Sep 2019 22:13:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Wrap the buffer from the caller to tpm_buf in
 tpm_send()
Message-ID: <20190917191307.GH10244@linux.intel.com>
References: <20190916085008.22239-1-jarkko.sakkinen@linux.intel.com>
 <20190916210331.l6enypnafk2cwako@cantor>
 <20190916210454.mq3g2m6s5a2syaxp@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916210454.mq3g2m6s5a2syaxp@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 02:04:54PM -0700, Jerry Snitselaar wrote:
> On Mon Sep 16 19, Jerry Snitselaar wrote:
> > On Mon Sep 16 19, Jarkko Sakkinen wrote:
> > > tpm_send() does not give anymore the result back to the caller. This
> > > would require another memcpy(), which kind of tells that the whole
> > > approach is somewhat broken. Instead, as Mimi suggested, this commit
> > > just wraps the data to the tpm_buf, and thus the result will not go to
> > > the garbage.
> > > 
> > > Obviously this assumes from the caller that it passes large enough
> > > buffer, which makes the whole API somewhat broken because it could be
> > > different size than @buflen but since trusted keys is the only module
> > > using this API right now I think that this fix is sufficient for the
> > > moment.
> > > 
> > > In the near future the plan is to replace the parameters with a tpm_buf
> > > created by the caller.
> > > 
> > > Reported-by: Mimi Zohar <zohar@linux.ibm.com>
> > > Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 412eb585587a ("use tpm_buf in tpm_transmit_cmd() as the IO parameter")
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > ---
> > > drivers/char/tpm/tpm-interface.c | 8 ++------
> > > 1 file changed, 2 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > > index d9ace5480665..2459d36dd8cc 100644
> > > --- a/drivers/char/tpm/tpm-interface.c
> > > +++ b/drivers/char/tpm/tpm-interface.c
> > > @@ -358,13 +358,9 @@ int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen)
> > > 	if (!chip)
> > > 		return -ENODEV;
> > > 
> > > -	rc = tpm_buf_init(&buf, 0, 0);
> > > -	if (rc)
> > > -		goto out;
> > > -
> > > -	memcpy(buf.data, cmd, buflen);
> > > +	buf.data = cmd;
> > > 	rc = tpm_transmit_cmd(chip, &buf, 0, "attempting to a send a command");
> > > -	tpm_buf_destroy(&buf);
> > > +
> > > out:
> > > 	tpm_put_ops(chip);
> > > 	return rc;
> > > -- 
> > > 2.20.1
> > > 
> > 
> > Nothing uses the out label any longer so it should be dropped as well, but other than that...
> > 
> > Acked-by: Jerry Snitselaar <jsnitsel@redhat.com>
> 
> sigh (wrong emacs macro hit), that should be:
> 
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

Thank you! I pushed the commit to master/next.

/Jarkko
