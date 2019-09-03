Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03078A6D1A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 17:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfICPlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 11:41:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbfICPlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 11:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ULjjH4sen9zfb9BXYRsup9ADAXBJxX8uc7RUDCdLvBI=; b=iMLtZaheRsuIIVHr5rl4845Z/
        DQ4Krr08gV8xH84IYbia5dX0+JhszL5ZcZBnSeyExOmZFBqXF7CcL2MNVCZCq9tyJtdZYKwrJmZCb
        EglUAwGDTmn5HoxA89fVRVoWsmuRCXZTwoEp2Q03cznjk1R5NHDz0Fo2WlVGzKhnuBdGIUo1hb3Y9
        uT4AtWQHg+LuKzFCXP79w6r3cLv6R7QKv1ZIzJHSzD3byMeBY9RB+Nqg9cSLyx5BUR2r8yRKVB/ny
        +O2cQUg5jS8QXvSKwizythOZTh3Qt2gWBn9gS3WJ0y5IR1cPNFSd53JleIPN/dwvgrOd3Pv3qQt+F
        WrdrrEDEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5Avd-0002Gk-UO; Tue, 03 Sep 2019 15:41:09 +0000
Date:   Tue, 3 Sep 2019 08:41:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] x86/platform/uv: Return UV Hubless System Type
Message-ID: <20190903154109.GB2791@infradead.org>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001815.893030884@stormcage.eag.rdlabs.hpecorp.net>
 <20190903064914.GA9914@infradead.org>
 <0eee6d96-e4fc-763b-a8b9-52c85ddd5531@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0eee6d96-e4fc-763b-a8b9-52c85ddd5531@hpe.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 07:12:28AM -0700, Mike Travis wrote:
> > > +#define is_uv_hubless _is_uv_hubless
> > 
> > Why the weird macro indirection?
> > 
> > > -static inline int is_uv_hubless(void)	{ return 0; }
> > > +static inline int _is_uv_hubless(int uv) { return 0; }
> > > +#define is_uv_hubless _is_uv_hubless
> > 
> > And here again.
> > 
> 
> Sorry, I should have explained this better.  The problem arises because
> we have a number of UV specific kernel modules that support multiple
> distributions.  And with back porting to earlier distros we cannot
> rely on the KERNEL_VERSION macro to define whether the source is being
> built for an earlier kernel.  So this allows an ifdef on the function
> name to discover if the kernel is before or after these changes.

And none of these matter for upstream.  We'd rather not make the code
more convouluted than required.  If you actually really cared about these
modules you would simply submit them upstream.
