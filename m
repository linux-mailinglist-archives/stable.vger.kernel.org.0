Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0875552A62
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 07:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344735AbiFUFD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 01:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344649AbiFUFDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 01:03:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D838F13FB1
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 22:03:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9374C1F8DE;
        Tue, 21 Jun 2022 05:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655787800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgw3YuBLSHGFCx10yEegZLjEeOpcPeSzbj+BDLn3bRI=;
        b=yhHasrb7C76KvHqEHKb5dzvzKuI7U1j0VBB0Ow6O197qwydVmq/NuN85HFmmc1A66/2L6y
        M1UKH8k22F+Uoa1CtZVWplO/Krdbx6+H1XMzjKoUbdNhrr+pjPFKWQ/8ztp5+xvE1cemSW
        U2HepzPVvZZ4SQaoEJw+0KjZakRXuKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655787800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgw3YuBLSHGFCx10yEegZLjEeOpcPeSzbj+BDLn3bRI=;
        b=ameHD2XviUQDPXzGqCWZ2mkqUYHrcGFXg+mipiLKLuylCo3zJ73p8dSoHSBdpKDYpsP7Ii
        Gg5LL1V0giArT/CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75F5F13638;
        Tue, 21 Jun 2022 05:03:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id C76OGxhRsWIuKwAAMHmgww
        (envelope-from <jslaby@suse.cz>); Tue, 21 Jun 2022 05:03:20 +0000
Message-ID: <0a063bd4-e719-6179-fd44-356617026539@suse.cz>
Date:   Tue, 21 Jun 2022 07:03:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: patch request for 5.18-stable to fix gcc-12 build
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
References: <YqxguwkPJhyvKbRk@debian> <YrBILWzY4ziMl7xE@kroah.com>
From:   Jiri Slaby <jslaby@suse.cz>
In-Reply-To: <YrBILWzY4ziMl7xE@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 06. 22, 12:13, Greg Kroah-Hartman wrote:
> On Fri, Jun 17, 2022 at 12:08:43PM +0100, Sudip Mukherjee wrote:
>> Hi Greg,
>>
>> v5.18.y riscv builds fails with gcc-12. Can I please request to add the
>> following to the queue:
>>
>> f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
>> 49beadbd47c2 ("gcc-12: disable '-Wdangling-pointer' warning for now")
>> 7e415282b41b ("virtio-pci: Remove wrong address verification in vp_del_vqs()")
>>
>> This is only for the config that fdsdk is using, I will start a full
>> allmodconfig to check if anything else is needed.
> 
> Now queued up, thanks.
> 
> I don't think 5.18 will build with gcc-12 for x86-64 yet either, I'm
> sticking with gcc-11 for my builds at the moment...

FWIW Tumbleweed compiles using gcc 12 since around 5.17.5. (Obviously, 
with CONFIG_WERROR unset.)

regards,
-- 
js
suse labs
