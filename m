Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517DA462F86
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbhK3J3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:29:30 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54402 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbhK3J33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:29:29 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D01EF1FD38;
        Tue, 30 Nov 2021 09:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638264369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VrNjR+cKjWqvCru8xHm8bTp+Pkam2GwW/d9esTlcJtc=;
        b=BfFOigi2kJ+8AzWslJS5oTAivHUGuZ+PqOhsPMTDTow6a27tCNZ4QIsa3ufhfjVWjgvDhp
        LUPVqEuxM43FHzl9zDq7Fy5lr6z92chjg5kZGfTCQGjTTvLythc+FpLgJCNG5hJjpFe4nF
        7QIcO/83q1KpC0Z49WinuJ1PUXZvE7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638264369;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VrNjR+cKjWqvCru8xHm8bTp+Pkam2GwW/d9esTlcJtc=;
        b=fk/cD1TkwjSJx6gj7NHyGOUo4uahcljTRdShlCy+WchST6fFB2J4NBDKB+h23gp4Ab1x9A
        WTN1PPpsWK7mugCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 74F7413C98;
        Tue, 30 Nov 2021 09:26:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B/DKGTHupWFxFwAAMHmgww
        (envelope-from <jdelvare@suse.de>); Tue, 30 Nov 2021 09:26:09 +0000
Date:   Tue, 30 Nov 2021 10:26:08 +0100
From:   Jean Delvare <jdelvare@suse.de>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     Hector Martin <marcan@marcan.st>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] i2c: i801: Safely share SMBus with BIOS/ACPI
Message-ID: <20211130102608.57e2171d@endymion>
In-Reply-To: <YaSWx7ldFfbCmrK3@kunai>
References: <20210626054113.246309-1-marcan@marcan.st>
        <YaSWx7ldFfbCmrK3@kunai>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 10:00:55 +0100, Wolfram Sang wrote:
> On Sat, Jun 26, 2021 at 02:41:13PM +0900, Hector Martin wrote:
> > The i801 controller provides a locking mechanism that the OS is supposed
> > to use to safely share the SMBus with ACPI AML or other firmware.
> > 
> > Previously, Linux attempted to get out of the way of ACPI AML entirely,
> > but left the bus locked if it used it before the first AML access. This
> > causes AML implementations that *do* attempt to safely share the bus
> > to time out if Linux uses it first; notably, this regressed ACPI video
> > backlight controls on 2015 iMacs after 01590f361e started instantiating
> > SPD EEPROMs on boot.
> > 
> > Commit 065b6211a8 fixed the immediate problem of leaving the bus locked,
> > but we can do better. The controller does have a proper locking mechanism,
> > so let's use it as intended. Since we can't rely on the BIOS doing this
> > properly, we implement the following logic:
> > 
> > - If ACPI AML uses the bus at all, we make a note and disable power
> >   management. The latter matches already existing behavior.
> > - When we want to use the bus, we attempt to lock it first. If the
> >   locking attempt times out, *and* ACPI hasn't tried to use the bus at
> >   all yet, we cautiously go ahead and assume the BIOS forgot to unlock
> >   the bus after boot. This preserves existing behavior.
> > - We always unlock the bus after a transfer.
> > - If ACPI AML tries to use the bus (except trying to lock it) while
> >   we're in the middle of a transfer, or after we've determined
> >   locking is broken, we know we cannot safely share the bus and give up.
> > 
> > Upon first usage of SMBus by ACPI AML, if nothing has gone horribly
> > wrong so far, users will see:
> > 
> > i801_smbus 0000:00:1f.4: SMBus controller is shared with ACPI AML. This seems safe so far.
> > 
> > If locking the SMBus times out, users will see:
> > 
> > i801_smbus 0000:00:1f.4: BIOS left SMBus locked
> > 
> > And if ACPI AML tries to use the bus concurrently with Linux, or it
> > previously used the bus and we failed to subsequently lock it as
> > above, the driver will give up and users will get:
> > 
> > i801_smbus 0000:00:1f.4: BIOS uses SMBus unsafely
> > i801_smbus 0000:00:1f.4: Driver SMBus register access inhibited
> > 
> > This fixes the regression introduced by 01590f361e, and further allows
> > safely sharing the SMBus on 2015 iMacs. Tested by running `i2cdump` in a
> > loop while changing backlight levels via the ACPI video device.
> > 
> > Fixes: 01590f361e ("i2c: i801: Instantiate SPD EEPROMs automatically")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Hector Martin <marcan@marcan.st>  
> 
> Jean, Heiner, what do we do with this topic?

I like the idea, I need to give it a try and review the code.

-- 
Jean Delvare
SUSE L3 Support
