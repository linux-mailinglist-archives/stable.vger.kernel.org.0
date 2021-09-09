Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9F140569C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352472AbhIINUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:20:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54084 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356944AbhIINPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:15:00 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 938501FDEE;
        Thu,  9 Sep 2021 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631193227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pFMRfoyR43hfi0VWujmUi6zgOxK+wVXStaOWAPl9ihk=;
        b=jwKuuIPjmKLoBl9qRZBKB49VW4UfAudv/rGnMyjKgBqPkpmrFqAOXvMM1+HsncTPIFyjLG
        UiDZJT/R9vrZyXHupExniDumvyGKGJvCfCBpsa80aGmMpDEj3K4weQaS47ndkZeu/EiaZN
        TRUZCzHzOZZcl2h+4MwOhVbdwy0qYR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631193227;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pFMRfoyR43hfi0VWujmUi6zgOxK+wVXStaOWAPl9ihk=;
        b=baFrK6w72S8VISeLlLZ1TZebCQin7lJIg4i8J+4B6Hlg2+qdOH9YOKCCx4rUfiZHL1MTLm
        pR13G4mWYUcgyqCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A5B513B36;
        Thu,  9 Sep 2021 13:13:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KFuqC4sIOmFKDwAAMHmgww
        (envelope-from <jdelvare@suse.de>); Thu, 09 Sep 2021 13:13:47 +0000
Date:   Thu, 9 Sep 2021 15:13:20 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 088/252] i2c: i801: Fix handling
 SMBHSTCNT_PEC_EN
Message-ID: <20210909151320.7bddd134@endymion>
In-Reply-To: <20210909114106.141462-88-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
        <20210909114106.141462-88-sashal@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sascha,

On Thu,  9 Sep 2021 07:38:22 -0400, Sasha Levin wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [ Upstream commit a6b8bb6a813a6621c75ceacd1fa604c0229e9624 ]
> 
> Bit SMBHSTCNT_PEC_EN is used only if software calculates the CRC and
> uses register SMBPEC. This is not supported by the driver, it supports
> hw-calculation of CRC only (using bit SMBAUXSTS_CRCE). The chip spec
> states the following, therefore never set bit SMBHSTCNT_PEC_EN.
> 
> Chapter SMBus CRC Generation and Checking
> If the AAC bit is set in the Auxiliary Control register, the PCH
> automatically calculates and drives CRC at the end of the transmitted
> packet for write cycles, and will check the CRC for read cycles. It will
> not transmit the contents of the PEC register for CRC. The PEC bit must
> not be set in the Host Control register. If this bit is set, unspecified
> behavior will result.
> 
> This patch is based solely on the specification and compile-tested only,
> because I have no PEC-capable devices.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Tested-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/i2c/busses/i2c-i801.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)

This patch fixes a theoretical problem nobody has ever complained
about. I don't think it makes sense to backport it to stable kernel
branches.

-- 
Jean Delvare
SUSE L3 Support
