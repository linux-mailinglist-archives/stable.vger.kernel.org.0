Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE521728CF
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 20:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgB0TjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 14:39:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727159AbgB0TjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 14:39:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582832354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jgsSpm8mCta/cft6DGl3blqQG92oahUcVRDoetuNafY=;
        b=Qsm7IX1BlM8pcdSuXR3oeh9vO8ptVzCFX0Vl/pvTkOhP106XBVpEcryHmg99im8bfz4Fhy
        k0k+Qs73cIR7zGLMuGS2hafudH+l6Dob/eTRJ8ZkX9mTIoaswn81qtV7gxIJmThTyMWDOa
        VvA7qCjpr+cZm0KGwN4DmAzkVdUv/aY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-ywh1NWywPMKVXHUtsPnHsg-1; Thu, 27 Feb 2020 14:39:09 -0500
X-MC-Unique: ywh1NWywPMKVXHUtsPnHsg-1
Received: by mail-wm1-f70.google.com with SMTP id r19so179619wmh.1
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 11:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jgsSpm8mCta/cft6DGl3blqQG92oahUcVRDoetuNafY=;
        b=VXK0Gs1BhKHylmg9VOPBN9dR4QDrIUPKOiV5wPEuflm3egbneRQupgTlRoSQ7O8gsV
         vGJSrql++PVdQhF3ZAmEjz4LkVsTbN0n9FQwHLUiNUTNpL+qSyDNZsI0RXEktCsY+rXg
         YmEC0gV1PD85O6sw4R8jXJfudpdU0exrRv2qftU5LE7bTnzXzS8TPdD8XHWsq3PjpvJU
         1t9vfenkfqhp3PZJaEhdlo+7R1M4PuLEIVSfzVW8ct4tJM+mgLZn9nPfhu7Ae+GQ7Lb7
         T3KBDjnEoFgxxzpWnfU/e1Q4qd2734iL62sKk37OsKvwL7lWf39L9xkwR1hLH5WqlpGB
         t1Hw==
X-Gm-Message-State: APjAAAWBktehYCJdzjxkhnf9RQzDQCxNqNliIKYu1FLUWSRR8g4nGtlI
        J6ygX7cpXkP3JD+f//M+eSUe1ztyTcNA/sudHVCulCdnwSa8tn4IhCCZkHZwRLkz7ruagVcn8Mu
        WetfBTMdc0O2LaHx1
X-Received: by 2002:a1c:41c3:: with SMTP id o186mr329392wma.27.1582832346266;
        Thu, 27 Feb 2020 11:39:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzt6B01dvTT3p77AIh+ZdGNWNChYvp4s/k2TEaC4ToW4fxA3JQ6a3yuFZ/6Rjg+Sfd49xTykw==
X-Received: by 2002:a1c:41c3:: with SMTP id o186mr329374wma.27.1582832346045;
        Thu, 27 Feb 2020 11:39:06 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id z21sm8897937wml.5.2020.02.27.11.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 11:39:05 -0800 (PST)
To:     stable@vger.kernel.org,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Jaroslav Kysela <perex@perex.cz>
From:   Hans de Goede <hdegoede@redhat.com>
Subject: 5.5.6 regression (stuck at boot) on devices using the sof_hda audio
 driver + fix
Message-ID: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
Date:   Thu, 27 Feb 2020 20:39:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

I and various other Fedora users have noticed that Fedora's 5.5.6 build gets stuck
at boot on a Lenovo X1 7th gen, see:
https://bugzilla.redhat.com/show_bug.cgi?id=1772498

This is caused by the addition of this commit to 5.5.6:

24c259557c45 ("ASoC: SOF: Intel: hda: Fix SKL dai count")
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.5.y&id=24c259557c45e817941d3843f82331a477c86a7e

###
ASoC: SOF: Intel: hda: Fix SKL dai count
[ Upstream commit a6947c9d86bcfd61b758b5693eba58defe7fd2ae ]

With fourth pin added for iDisp for skl_dai, update SOF_SKL_DAI_NUM to
account for the change. Without this, dais from the bottom of the list
are skipped. In current state that's the case for 'Alt Analog CPU DAI'.

Fixes: ac42b142cd76 ("ASoC: SOF: Intel: hda: Add iDisp4 DAI")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200113114054.9716-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
###

Notice the "Fixes: ac42b142cd76 (...)", that commit-id actually
does not exist, the correct commit-id which this fixes is:

e68d6696575e ("ASoC: SOF: Intel: hda: Add iDisp4 DAI")
and that commit is not in 5.5.6, which is causing the problem,
the missing commit makes an array one larger and the fix for the
missing fix which did end up in 5.5.6 and bumps a define which is
used to walk over the array in some places by one so now the
walking is going over the array boundary.

For the Fedora kernels I've fixed this by adding the
"ASoC: SOF: Intel: hda: Add iDisp4 DAI" commit as a downstream
patch for our kernels. I believe that this is probably the best
fix for 5.5.z too.

Regards,

Hans


p.s.

I know that the stable series are partly based on automatically
picking patches now. I wonder if the scripts doing that could be
made smarter wrt rejecting patches with a Fixes tag where the
fixed patch is not present, so where in essence a pre-requisite
of the patch being added is missing ?

