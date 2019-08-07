Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8998439E
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 07:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbfHGFSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 01:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfHGFSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 01:18:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13CB217D7;
        Wed,  7 Aug 2019 05:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565155122;
        bh=2CHfavmayPi4Q4Um/B9uDR6af4m0sXzNVY+hOxvF/2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ELMc1W/w9+8/qniSuJqkm8jtd6FIrqbZg4moXipZSWpr3rxRNRNZ5ug+0fFX562c0
         34tHnsMPlVbEKY2XF2MKoKWMKMcHAtu+Zk7aw9PlBBwgu1etBQ1a9ayJn4cExFBcoN
         LYak4MKSoz1UiS3CXIsDKtV2bukFAd3QfHXa3iqw=
Date:   Wed, 7 Aug 2019 07:18:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Gerecke, Jason" <killertofu@gmail.com>
Cc:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Correct distance scale for 2nd-gen Intuos
 devices
Message-ID: <20190807051839.GA26833@kroah.com>
References: <20190806205805.21168-1-jason.gerecke@wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806205805.21168-1-jason.gerecke@wacom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 01:58:05PM -0700, Gerecke, Jason wrote:
> From: Jason Gerecke <jason.gerecke@wacom.com>
> 
> Distance values reported by 2nd-gen Intuos tablets are on an inveted scale
> (0 == far, 63 == near). We need to change them over to a normal scale before
> reporting to userspace or else userspace drivers and applications can get
> confused.
> 
> Ref: https://github.com/linuxwacom/input-wacom/issues/98
> Fixes: eda01dab53 ("HID: wacom: Add four new Intuos devices")
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Cc: <stable@vger.kernel.org> # v4.4+
> ---
>  drivers/hid/wacom_wac.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index 7a8ddc999a8e..879e41fbf604 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -846,6 +846,9 @@ static int wacom_intuos_general(struct wacom_wac *wacom)
>  		y >>= 1;
>  		distance >>= 1;
>  	}
> +	if (features->type == INTUOSHT2) {
> +		distance = features->distance_max - distance;
> +	}

{ } not needed, always run checkpatch.pl before sending stuff out :(

