Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44FE39C7A9
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 13:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFELHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 07:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhFELHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 07:07:34 -0400
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Jun 2021 04:05:46 PDT
Received: from rhcavspool01.kulnet.kuleuven.be (rhcavspool01.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA9AC061766
        for <stable@vger.kernel.org>; Sat,  5 Jun 2021 04:05:46 -0700 (PDT)
Received: from icts-p-cavuit-3.kulnet.kuleuven.be (icts-p-cavuit-3.kulnet.kuleuven.be [134.58.240.133])
        by rhcavspool01.kulnet.kuleuven.be (Postfix) with ESMTP id EA4566027
        for <stable@vger.kernel.org>; Sat,  5 Jun 2021 12:57:54 +0200 (CEST)
X-KULeuven-Envelope-From: mathy.vanhoef@kuleuven.be
X-Spam-Status: not spam, SpamAssassin (not cached, score=-50.59, required 5,
        autolearn=disabled, NICE_REPLY_A -0.59, RCVD_SMTPS -50.00,
        SPF_HELO_NONE 0.00, SPF_PASS -0.00)
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 7710B20829.A1E85
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-smtps-1.cc.kuleuven.be (icts-p-smtps-1e.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:33])
        by icts-p-cavuit-3.kulnet.kuleuven.be (Postfix) with ESMTP id 7710B20829
        for <stable@vger.kernel.org>; Sat,  5 Jun 2021 12:57:33 +0200 (CEST)
X-CAV-Cluster: smtps
Received: from [172.20.6.62] (bba146567.alshamil.net.ae [217.165.158.9])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by icts-p-smtps-1.cc.kuleuven.be (Postfix) with ESMTPSA id 4CBD840B2;
        Sat,  5 Jun 2021 12:57:32 +0200 (CEST)
Subject: Re: [PATCH 5.10 024/252] mac80211: prevent mixed key and fragment
 cache attacks
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130658.804599277@linuxfoundation.org> <20210601092619.GA30422@amd>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Message-ID: <52ae0752-422e-b791-365a-228c968ffed9@kuleuven.be>
Date:   Sat, 5 Jun 2021 14:57:30 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210601092619.GA30422@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Pavel,

Good remark. In practice this doesn't look like a problem: the overflow
would need to happen in less than two seconds. If it takes longer, the
mixed key and cache attack cannot be performed because the previous
fragment(s) will be discarded, see
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/mac80211/rx.c?h=v5.13-rc4&id=8124c8a6b35386f73523d27eacb71b5364a68c4c#n2202

It may be useful to add this as a comment to the code.

Cheers,
Mathy

On 6/1/21 1:26 PM, Pavel Machek wrote:
> Hi!
> 
>> From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
>>
>> commit 94034c40ab4a3fcf581fbc7f8fdf4e29943c4a24 upstream.
>>
>> Simultaneously prevent mixed key attacks (CVE-2020-24587) and fragment
>> cache attacks (CVE-2020-24586). This is accomplished by assigning a
>> unique color to every key (per interface) and using this to track which
>> key was used to decrypt a fragment. When reassembling frames, it is
>> now checked whether all fragments were decrypted using the same key.
>>
>> To assure that fragment cache attacks are also prevented, the ID that is
>> assigned to keys is unique even over (re)associations and (re)connects.
>> This means fragments separated by a (re)association or (re)connect will
>> not be reassembled. Because mac80211 now also prevents the reassembly of
>> mixed encrypted and plaintext fragments, all cache attacks are
>> prevented.
> 
>> --- a/net/mac80211/key.c
>> +++ b/net/mac80211/key.c
>> @@ -799,6 +799,7 @@ int ieee80211_key_link(struct ieee80211_
>>  		       struct ieee80211_sub_if_data *sdata,
>>  		       struct sta_info *sta)
>>  {
>> +	static atomic_t key_color = ATOMIC_INIT(0);
>>  	struct ieee80211_key *old_key;
> 
> This is nice and simple, but does not include any kind of overflow
> handling. sparc32 moved away from 24-bit atomics, which is good I
> guess. OTOH if this is incremented 10 times a second, we'll still
> overflow in 6 years or so. Can attacker make it overflow?
> 
> Should this have a note why overflow is not possible / why it is not a
> problem?
> 
> Best regards,
> 								Pavel
> 
