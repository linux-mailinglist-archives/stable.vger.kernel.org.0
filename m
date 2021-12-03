Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A32467343
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 09:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379143AbhLCIdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 03:33:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43908 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244052AbhLCIdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 03:33:31 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CF2341FD3C;
        Fri,  3 Dec 2021 08:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638520206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Paxz2PbJ3ABf+QoTLmxZAgh9n+0xzk9SrTohSl7pwkk=;
        b=kSucru1oKEfVRiHRu1oP/o1hAlmjYzR6N1aqQkXeKPmOgQxONBO1VjrJZQAHUHF5fE52yK
        MlZRkecJY7d5lWC5Pj5O8+F2xOTZMG+lFeiTFyBp7s+ZshnszmlL2we/O/jv8uGCjB1+HY
        YbDQFyl2bgCxEWZ+bbn9RmPUJ+qxu2w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638520206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Paxz2PbJ3ABf+QoTLmxZAgh9n+0xzk9SrTohSl7pwkk=;
        b=DVfinWFywF5kZKWZWEwp8ExveJDu/qnzWEOkQDaS4mxPYupKcKpenuxvsa0c/qmmgyaU66
        2teZ3yw2Pff/IBAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6883B13CF5;
        Fri,  3 Dec 2021 08:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Di5XF47VqWGRWQAAMHmgww
        (envelope-from <jdelvare@suse.de>); Fri, 03 Dec 2021 08:30:06 +0000
Date:   Fri, 3 Dec 2021 09:30:05 +0100
From:   Jean Delvare <jdelvare@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        ck+kernelbugzilla@bl4ckb0x.de, stephane.poignant@protonmail.com,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 35/68] i2c: i801: Fix interrupt storm from
 SMB_ALERT signal
Message-ID: <20211203093005.4337dfde@endymion>
In-Reply-To: <20211130144707.944580-35-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
        <20211130144707.944580-35-sashal@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, 30 Nov 2021 09:46:31 -0500, Sasha Levin wrote:
> From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> 
> [ Upstream commit 03a976c9afb5e3c4f8260c6c08a27d723b279c92 ]
> 
> Currently interrupt storm will occur from i2c-i801 after first
> transaction if SMB_ALERT signal is enabled and ever asserted. It is
> enough if the signal is asserted once even before the driver is loaded
> and does not recover because that interrupt is not acknowledged.
> 
> This fix aims to fix it by two ways:
> - Add acknowledging for the SMB_ALERT interrupt status
> - Disable the SMB_ALERT interrupt on platforms where possible since the
>   driver currently does not make use for it
> 
> Acknowledging resets the SMB_ALERT interrupt status on all platforms and
> also should help to avoid interrupt storm on older platforms where the
> SMB_ALERT interrupt disabling is not available.
> 
> For simplicity this fix reuses the host notify feature for disabling and
> restoring original register value.
> (...)

If you are backporting this, then I think you should also include:

commit 9b5bf5878138293fb5b14a48a7a17b6ede6bea25
Author: Jean Delvare
Date:   Tue Nov 9 16:02:57 2021 +0100

    i2c: i801: Restore INTREN on unload

which is the first half of the fix for the same bug. Jarkko's patch
fixes the interrupt storm while the driver is loaded, mine fixes it
after the driver is unloaded (or when the device is handed over to the
BIOS, at suspend or reboot).

-- 
Jean Delvare
SUSE L3 Support
