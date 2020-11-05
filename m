Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351E42A837B
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKEQ0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731224AbgKEQ0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:26:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27C8A20936;
        Thu,  5 Nov 2020 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604593565;
        bh=AleGPPaZ8rEKySOugD/QIrmAVOp6hLxKjVliIx3SA1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pa2PmxQ9T6IeimCw5dpnnWrZizlGhbWr81133S383TN+SFKztcN8641X7zueWZpj7
         OKJqgHhec9UruwRMggW8iWeVAIIuEdmmrjXOWGD7vmUm3uB1T5thudu8N0yISHaUcp
         k/1zniHVzgYdGbpKmuWlNv49DGSi3b8CyuPjKoV0=
Date:   Thu, 5 Nov 2020 17:26:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, Paul Bolle <pebolle@tiscali.nl>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.9 080/391] ASoC: SOF: fix a runtime pm issue in SOF
 when HDMI codec doesnt work
Message-ID: <20201105162653.GA1175591@kroah.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <20201103203352.505472614@linuxfoundation.org>
 <64a618a3cc00de4a1c3887b57447906351db77b9.camel@tiscali.nl>
 <20201105143551.GH2092@sasha-vm>
 <1f0c6a62-5208-801d-d7c2-725ee8da19b2@linux.intel.com>
 <20201105154426.GI2092@sasha-vm>
 <e13d8fb6-4f69-23ad-22f6-499bffbf03d6@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e13d8fb6-4f69-23ad-22f6-499bffbf03d6@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 10:17:57AM -0600, Pierre-Louis Bossart wrote:
> 
> > > > > My local build of v5.9.5 broke on this patch.
> > > > > 
> > > > > sound/soc/sof/intel/hda-codec.c: In function 'hda_codec_probe':
> > > > > sound/soc/sof/intel/hda-codec.c:177:4: error: label 'error'
> > > > > used but not defined
> > > > >  177 |    goto error;
> > > > >      |    ^~~~
> > > > > make[4]: *** [scripts/Makefile.build:283:
> > > > > sound/soc/sof/intel/hda-codec.o] Error 1
> > > > > make[3]: *** [scripts/Makefile.build:500: sound/soc/sof/intel] Error 2
> > > > > make[2]: *** [scripts/Makefile.build:500: sound/soc/sof] Error 2
> > > > > make[1]: *** [scripts/Makefile.build:500: sound/soc] Error 2
> > > > > make: *** [Makefile:1778: sound] Error 2
> > > > > 
> > > > > There's indeed no error label in v5.9.5. (There is one in
> > > > > v5.10-rc2, I just
> > > > > checked.) Is no-one else running into this?
> > > > 
> > > > It seems that setting CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y is very
> > > > "difficult", it's not being set by allmodconfig nor is it easy to
> > > > manually set it up.
> > > > 
> > > > I'll revert the patch, but it would be nice to make sure it's easier to
> > > > test this out too.
> > > 
> > > this issue comes from out-of-order patches, give me a couple of
> > > hours to look into this before reverting. thanks!
> > 
> > Sure! Thanks for looking into this.
> 
> I would recommend adding this commit to 5.9-stable:
> 
> 11ec0edc6408a ('ASOC: SOF: Intel: hda-codec: move unused label to correct
> position')
> 
> I just tried with 5.9.5 and the compilation error is solved with this
> commit.
> 
> It was initially intended to solve a minor 'defined but not used' issue,
> which somehow became a bad 'used but not defined' one. Probably a bad git
> merge I did, sorry about that.

Will go do that now and push out a new release, thanks!

greg k-h
