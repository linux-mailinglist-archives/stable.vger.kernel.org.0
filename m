Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C7E8E735
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 10:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfHOIrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 04:47:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36631 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfHOIrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 04:47:36 -0400
Received: from [114.252.209.139] (helo=[192.168.1.108])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hyBPx-0007AW-1w; Thu, 15 Aug 2019 08:47:33 +0000
Subject: Re: [alsa-devel] [PATCH 1/2] ALSA: hda - Add a new match function for
 only undef configurations
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
References: <20190815083001.3793-1-hui.wang@canonical.com>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <27ec2712-abdf-6387-8f3d-995e14636fdd@canonical.com>
Date:   Thu, 15 Aug 2019 16:47:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815083001.3793-1-hui.wang@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, please ignore this patchset, don't plan to send this patchset to 
stable and there is some issue in the patch, will send v2.

On 2019/8/15 下午4:30, Hui Wang wrote:
> With the existing pintbl, we already have many entries in it. it is
> better to figure out a new match to reduce the size of the pintbl.
>
> For example, there are over 10 entries in the pintbl for:
> 0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
>
> If we define a new tbl like below, and with the new adding match
> function, we can remove those over 10 entries:
> SND_HDA_PIN_QUIRK(0x10ec0255, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
> 	{0x19, 0x40000000},
> 	{0x1a, 0x40000000},),
>
> Here we put 0x19 and 0x1a in the tbl just because these two pins are
> undefined on Dell laptops with the codec alc255, and these two pins
> will be overwritten by ALC255_FIXUP_DELL1_MIC_NO_PRESENCE.
>
> In summary: the new match will check vendor id and codec id first,
> then check the pin_cfg defined in the tbl, only all pin_cfgs in the
> tbl are undef and the corresponding pin_cfgs on the laptop are undef
> too, this match returns true.
>
> This new match function has lower priority than existing match
> functions, so the existing tbls still work as before after applying this
> patch.
>
> My plan is to change the existing tbl to undef tbl for MIC_NO_PRESENCE
> fixups gradually.
>
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>   sound/pci/hda/hda_auto_parser.c | 32 +++++++++++++++++++++++++++++++-
>   1 file changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/sound/pci/hda/hda_auto_parser.c b/sound/pci/hda/hda_auto_parser.c
> index 92390d457567..cfada7401b86 100644
> --- a/sound/pci/hda/hda_auto_parser.c
> +++ b/sound/pci/hda/hda_auto_parser.c
> @@ -915,6 +915,36 @@ static bool pin_config_match(struct hda_codec *codec,
>   	return true;
>   }
>   
> +/* match the pintbl which only contains specific pins with undef configuration */
> +static bool pin_config_match_undef(struct hda_codec *codec,
> +				   const struct hda_pintbl *pins)
> +{
> +	bool match = false;
> +
> +	for (; pins->nid; pins++) {
> +		const struct hda_pincfg *pin;
> +		int i;
> +
> +		if ((pins->val & 0xf0000000) != 0x40000000)
> +			return false;
> +
> +		match = false;
> +		snd_array_for_each(&codec->init_pins, i, pin) {
> +			if (pin->nid != pins->nid)
> +				continue;
> +			if ((pin->cfg & 0xf0000000) != 0x40000000)
> +				return false;
> +			match = true;
> +			break;
> +		}
> +
> +		if (match == false)
> +			return false;
> +	}
> +
> +	return match;
> +}
> +
>   /**
>    * snd_hda_pick_pin_fixup - Pick up a fixup matching with the pin quirk list
>    * @codec: the HDA codec
> @@ -935,7 +965,7 @@ void snd_hda_pick_pin_fixup(struct hda_codec *codec,
>   			continue;
>   		if (codec->core.vendor_id != pq->codec)
>   			continue;
> -		if (pin_config_match(codec, pq->pins)) {
> +		if (pin_config_match(codec, pq->pins) || pin_config_match_undef(codec, pq->pins)) {
>   			codec->fixup_id = pq->value;
>   #ifdef CONFIG_SND_DEBUG_VERBOSE
>   			codec->fixup_name = pq->name;
