Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633CB44CB6E
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 22:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhKJVyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 16:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhKJVyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 16:54:25 -0500
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E47BC061766;
        Wed, 10 Nov 2021 13:51:37 -0800 (PST)
Received: from [172.16.24.131] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb@iki.fi)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id C5C051B00220;
        Wed, 10 Nov 2021 23:51:32 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1636581093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZvy7+4ke6gcvCXJY15cL0WpUb0QAYMlT/N7RHXp8aI=;
        b=o5/NaDnzqsuqTMeSV9F8wmsPj5BqOHDlVEHDgMYLITvRYfPGS420F60UQaZZs1ghraUjrc
        2fBEOWkOVSbCLOnEVkRAFTWnYlw+B8IVoHw7KVZ2KqeJed5SD9ckSuC2gVsApykP5He/A0
        FFM5RO0OUjMNhlWsmEs9TdrX+/kpXzH2PBnexQVFgrGDWaVlhyAX7iVz9tk8NDDGvVsbuj
        Dqpki05l3bGunknJO97EWyYbMYDwPMhzhNwRmKYcMEs2jHQcjuHcw9LUQhPvuOq9rPaCrX
        4Z1bUJGy0sJ/Y8NhJYvwb3YLWIDGQUA/sI2PWr/0m74oXmWHtGqkwXm49YbeZA==
Message-ID: <958106af-e5ae-af6a-478d-c1eaef8e1498@iki.fi>
Date:   Wed, 10 Nov 2021 23:51:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 1/2] x86/PCI: Ignore E820 reservations for bridge
 windows on newer systems
Content-Language: en-US
To:     Hans de Goede <hdegoede@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Benoit_Gr=c3=a9goire?= <benoitg@coeus.ca>,
        Hui Wang <hui.wang@canonical.com>, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20211109220717.GA1187103@bhelgaas>
 <70b63cc2-4d08-8468-1ca7-135492394773@redhat.com>
 <1a001812-1f18-1999-44b7-30fe3a19f460@redhat.com>
From:   Thomas Backlund <tmb@iki.fi>
In-Reply-To: <1a001812-1f18-1999-44b7-30fe3a19f460@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1636581093; a=rsa-sha256;
        cv=none;
        b=wLTSyXUo5DDlbrbaMJkw6T2QEAwFwAQgdJU/B+AXxYJmcrFSFoOnMIhHWh60bypDZmdZ9V
        La1B1gU3Y9QPQAteMU1amgn4md+Pw93RcIC5RQVTNtqT2RqtoQXUKoNWf4Mr9BaiaicxFT
        2Bu5DYg0DSjqYB6kuc5PL1do01SLi9wEAkxGpiOIGIiD3+Tk8eH3AY/l1n1GS07+pqy4Vp
        NZZBT37o/NYxSfuY5rfFiqJ222JhtL37pyAmIM26wadkPErzTYdLfGZYxbOB415Lxeotrg
        PPgY7tzhNE8iRAjhwgzYZbmBrajJmlvJxPXbQCsmQU0/aUF2HU9SdJB3yAdkfQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb@iki.fi smtp.mailfrom=tmb@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1636581093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZvy7+4ke6gcvCXJY15cL0WpUb0QAYMlT/N7RHXp8aI=;
        b=dTe1jWKKoDIugCTS1pp2j+cQkKdhFUWHKeyNIrgEzhfMsDxXfQ60n9SHtHYgemFS5e8R63
        v5rkmHGK/cRyttqwJ0aT//ojCNFkfnVkQzrFrP4JFnYffOkbma2c7U1YSm1dIL4FE1SYem
        cCSRPEbyiUTsthFDQU9y4egTjdOhPkZOWEsEQYyN+rh1mSgpB6NsAN4mqZ45u9c4/+sbFW
        cRv3gCz7sDii6jGOAn6671xqSCw7G1J3TsTP0lCbqPajgVqyLpC4Eg2TRlWh1ANzrUhQBG
        PkhjxRRivj406SSBYc5jBgAXdIEeCHTGq3IkrlfBrMXwgwdR44i8jW9x8TFzUg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2021-11-10 kl. 15:05, skrev Hans de Goede:

> 
> So I've discussed this with the Fedora kernel maintainers and they have
> agreed to add the patch to the Fedora 5.15 kernels, which we will ask
> our users to start testing soon (we first run some voluntary testing
> before eventually moving all users over).
> 
> This will provide us with valuable feedback wrt this patch causing
> regressions as you are worried about, or not.
> 
> Assuming no regressions show up I hope that this will give you
> some assurance that there the patch causes no regressions and that
> you will then be willing to pick this up later during the 5.16
> cycle so that Fedora only deviates from upstream for 1 cycle.
> 

FWIW... As an extra data point...

I've backported this one on top of 5.14.14 in Mageia Cauldron and Mageia 
8 backports where it has been in active use for ~3 weeks now, and so far 
no reports of systems breaking ...

--
Thomas
