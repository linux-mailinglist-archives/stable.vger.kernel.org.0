Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBD33DF0C9
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhHCOvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:51:24 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55646 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbhHCOvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 10:51:23 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C3FEA2003E;
        Tue,  3 Aug 2021 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628002271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1PAUuxbm279noUJYK+2TINkJ8jnjsLCKOAQxIlYn3fU=;
        b=ik3DDOLN3KAwl+H0dQ5f2Dwd9Wvh566q/5UAu7qfixOfdpR1wzexpQMV5k4ei0cDotySWm
        gdgOg/bqF1L09WxTsYmwnsuyMFpT1zOqfJyrmpza8puJeZYVUD2GmIZZGv5zXp6yX7QINg
        Vb8q3HA9F4QcdnX8O/6LbLGGC5synVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628002271;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1PAUuxbm279noUJYK+2TINkJ8jnjsLCKOAQxIlYn3fU=;
        b=treT+NlWqGgfkNZ6sNhbOlQmN03hnRauEeb+lioUxMmm5yIm2Vc7uAOEPM7cc0u+H8cufI
        MUGTO+DcqFO2rFBg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 5FCB213B74;
        Tue,  3 Aug 2021 14:51:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id RN9fFN9XCWGObQAAGKfGzw
        (envelope-from <jdelvare@suse.de>); Tue, 03 Aug 2021 14:51:11 +0000
Date:   Tue, 3 Aug 2021 16:51:08 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Michael Marley <michael@michaelmarley.com>
Subject: Faulty commit "watchdog: iTCO_wdt: Account for rebooting on second
 timeout"
Message-ID: <20210803165108.4154cd52@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Commit cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on
second timeout") causes a regression on several systems. Symptoms are:
system reboots automatically after a short period of time if watchdog
is enabled (by systemd for example). This has been reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=213809

Unfortunately this commit was backported to all stable kernel branches
(4.14, 4.19, 5.4, 5.10, 5.12 and 5.13). I'm not sure why that is the
case, BTW, as there is no Fixes tag and no Cc to stable@vger either.
And the fix is not trivial, has apparently not seen enough testing,
and addresses a problem that has a known and simple workaround. IMHO it
should never have been accepted as a stable patch in the first place.
Especially when the previous attempt to fix this issue already ended
with a regression and a revert.

Anyway... After a glance at the patch, I see what looks like a nice
thinko:

+	if (p->smi_res &&
+	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))

The author most certainly meant inl(SMI_EN(p)) (the register's value)
and not SMI_EN(p) (the register's address).

-- 
Jean Delvare
SUSE L3 Support
