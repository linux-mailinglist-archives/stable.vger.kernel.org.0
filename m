Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582C93FF211
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbhIBRIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 13:08:41 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33244 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbhIBRIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 13:08:41 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 97D811FFC5;
        Thu,  2 Sep 2021 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630602461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5OzWCuEKWEp4QtFVuqotTWTSM6aFfFFxPEZwHhYHy8=;
        b=gV4g2tNA1ZlbHoUBTjb+nPpgiBqJ//WB125aRi/KHI9zzkooBDwZyFTc2WIvRnxAvDBVMi
        I6EJ+HyY/i+bsYukLUTzLQIWMK+bnCsUmEJJuuAJ8F3eoVvFUOq6ggenyk4yRjVuv4sNPj
        0vq5IrKcH7dt3hxaB1FgT03P4vRYWP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630602461;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5OzWCuEKWEp4QtFVuqotTWTSM6aFfFFxPEZwHhYHy8=;
        b=LJDRhhv5ijJoiHDsAXZq23SfEYfaq8ZGepXBE7wLayMG9EhTfn5/iMSBdT33nMUcAmULzG
        N+5xiijKlB2RCKBg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 37E5513AE2;
        Thu,  2 Sep 2021 17:07:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id B51bCt0EMWFVTwAAGKfGzw
        (envelope-from <jdelvare@suse.de>); Thu, 02 Sep 2021 17:07:41 +0000
Date:   Thu, 2 Sep 2021 19:07:39 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai-Chuan Hsieh <kaichuan.hsieh@canonical.com>,
        Erwan Velu <e.velu@criteo.com>
Subject: Re: [PATCH regression fix] firmware/dmi: Move product_sku info to
 the end of the modalias
Message-ID: <20210902190739.686eb8b1@endymion>
In-Reply-To: <20210831130508.14511-1-hdegoede@redhat.com>
References: <20210831130508.14511-1-hdegoede@redhat.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

On Tue, 31 Aug 2021 15:05:08 +0200, Hans de Goede wrote:
> Commit e26f023e01ef ("firmware/dmi: Include product_sku info to modalias")
> added a new field to the modalias in the middle of the modalias, breaking
> some existing udev/hwdb matches on the whole modalias without a wildcard
> ('*') in between the pvr and rvn fields.
> 
> All modalias matches in e.g. :
> https://github.com/systemd/systemd/blob/main/hwdb.d/60-sensor.hwdb
> deliberately end in ':*' so that new fields can be added at *the end* of
> the modalias, but adding a new field in the middle like this breaks things.
> 
> Move the new sku field to the end of the modalias to fix some hwdb
> entries no longer matching.

Argh. Sorry for missing that, and thanks a lot for spotting it,
reporting it and providing a fix. I never liked the modalias format as
it makes matches clearly fragile. I really need to keep this in mind
when touching it.

Patch applied and pushed to linux-next. I'll send it to Linus for
5.14.1 quickly too.

-- 
Jean Delvare
SUSE L3 Support
