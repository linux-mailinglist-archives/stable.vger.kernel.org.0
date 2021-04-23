Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C6C369B7B
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 22:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhDWUpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 16:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhDWUpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 16:45:41 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B94FC061574;
        Fri, 23 Apr 2021 13:45:02 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x20so49065973lfu.6;
        Fri, 23 Apr 2021 13:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H1pKvrLPooCfDxgOHq5YwIMwP0kH7IA1sQ6mtjIIn04=;
        b=U4ngz44ZjspORE5DUzD2u2VTWdvXWeHX6s/cHUQFTSNKiqQQNKW0YxTNGk4Z+V0LTB
         mAAf7tDUx/BVcGk3J29XKx6dhfkFezqFv14PQN1TR8dZpaiO+f1GwfBAWuQjSZ+hF2Fi
         A1VepEkMnPamc+xmm+cPE9mjXOQBJ8Z8SCMPOfADidgjN5/Yigs/VPwGEleaTs6gWCdQ
         P8pZR01xN/RbdU4tebKEDBCFfk8JP0Kx/NRKxPLik7O6CnIc5lw5YMfmVB/NprgU4Qmz
         D1xdVaN9khs2IH18G93z0KYTifmVc02eSYzffCf3NH6O+hqrGHI7L82okNGiOvbYn/p2
         0gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H1pKvrLPooCfDxgOHq5YwIMwP0kH7IA1sQ6mtjIIn04=;
        b=El8rZo05ciW4bRZm23aXboNdX55dQ2QyjLolq29Lrh7F/oZFfexJJAGCTqPQaBSxxy
         3mVQkI5MjdBdBNoJopoGmOzoZzFBKi3sx61kZdC478/Mrh/MSDY0ssVercGV1K8pRMNF
         4/lpZSMV5nVh6wCIWIpxf67DUugQc7lqtK2lJ7bDpe0ByE3Qd7rhMS5/MjOtcPkFXB7H
         LRqR/zXChT7eOPFEwN04ecsHEfv9SjinOIm8/v9NLOBSteWyrWM5rzil58eom2qPqVfF
         wp7DrtwG340MbuZvef8mnx4imWzO5TjXjsVrhAmISbR3c7rPjxihvM9pWOZXPNowWE4I
         LQ8Q==
X-Gm-Message-State: AOAM531XvB0tIq+UChHSrRcdhBbwosoMvm3Cq/dd54UVw1ZFInqKFLjK
        RSV2S8SYZjwCi97DiGgjNIo=
X-Google-Smtp-Source: ABdhPJz1up9mi0tlHxEZbkuZ1mgVJljt1EzZeK8mmmxdR5o3Lk1jLRrFQ8QFdsmnmRtSY6VACWdtqg==
X-Received: by 2002:a05:6512:3e27:: with SMTP id i39mr4064659lfv.581.1619210700698;
        Fri, 23 Apr 2021 13:45:00 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.147])
        by smtp.gmail.com with ESMTPSA id k18sm641058lfj.203.2021.04.23.13.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 13:45:00 -0700 (PDT)
Date:   Fri, 23 Apr 2021 23:44:58 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Atul Gopinathan <atulgopinathan@gmail.com>,
        syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        mchehab@kernel.org, linux-kernel-mentees@lists.linuxfoundation.org,
        linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl
Subject: Re: [PATCH] media: gspca: stv06xx: Fix memleak in stv06xx
 subdrivers
Message-ID: <20210423234458.3f754de2@gmail.com>
In-Reply-To: <36f126fc-6a5e-a078-4cf0-c73d6795a111@linuxfoundation.org>
References: <20210422160742.7166-1-atulgopinathan@gmail.com>
        <20210422215511.01489adb@gmail.com>
        <36f126fc-6a5e-a078-4cf0-c73d6795a111@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Fri, 23 Apr 2021 14:19:15 -0600
Shuah Khan <skhan@linuxfoundation.org> wrote:
> On 4/22/21 12:55 PM, Pavel Skripkin wrote:
> > Hi!
> > 
> > On Thu, 22 Apr 2021 21:37:42 +0530
> > Atul Gopinathan <atulgopinathan@gmail.com> wrote:
> >> During probing phase of a gspca driver in "gspca_dev_probe2()", the
> >> stv06xx subdrivers have certain sensor variants (namely, hdcs_1x00,
> >> hdcs_1020 and pb_0100) that allocate memory for their respective
> >> sensor which is passed to the "sd->sensor_priv" field. During the
> >> same probe routine, after "sensor_priv" allocation, there are
> >> chances of later functions invoked to fail which result in the
> >> probing routine to end immediately via "goto out" path. While
> >> doing so, the memory allocated earlier for the sensor isn't taken
> >> care of resulting in memory leak.
> >>
> >> Fix this by adding operations to the gspca, stv06xx and down to the
> >> sensor levels to free this allocated memory during gspca probe
> >> failure.
> >>
> >> -
> >> The current level of hierarchy looks something like this:
> >>
> >> 	gspca (main driver) represented by struct gspca_dev
> >> 	   |
> >> ___________|_____________________________________
> >> |	|	|	|	|		| (subdrivers)
> >> 			|			  represented
> >>   			stv06xx			  by
> >> "struct sd" |
> >>   	 _______________|_______________
> >>   	 |	|	|	|	|  (sensors)
> >> 	 	|			|
> >>   		hdcs_1x00/1020		pb01000
> >> 			|_________________|
> >> 				|
> >> 			These three sensor variants
> >> 			allocate memory for
> >> 			"sd->sensor_priv" field.
> >>
> >> Here, "struct gspca_dev" is the representation used in the top
> >> level. In the sub-driver levels, "gspca_dev" pointer is cast to
> >> "struct sd*", something like this:
> >>
> >> 	struct sd *sd = (struct sd *)gspca_dev;
> >>
> >> This is possible because the first field of "struct sd" is
> >> "gspca_dev":
> >>
> >> 	struct sd {
> >> 		struct gspca_dev;
> >> 		.
> >> 		.
> >> 	}
> >>
> >> Therefore, to deallocate the "sd->sensor_priv" fields from
> >> "gspca_dev_probe2()" which is at the top level, the patch creates
> >> operations for the subdrivers and sensors to be invoked from the
> >> gspca driver levels. These operations essentially free the
> >> "sd->sensor_priv" which were allocated by the "config" and
> >> "init_controls" operations in the case of stv06xx sub-drivers and
> >> the sensor levels.
> >>
> >> This patch doesn't affect other sub-drivers or even sensors who
> >> never allocate memory to "sensor_priv". It has also been tested by
> >> syzbot and it returned an "OK" result.
> >>
> >> https://syzkaller.appspot.com/bug?id=ab69427f2911374e5f0b347d0d7795bfe384016c
> >> -
> >>
> >> Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New
> >> subdriver.") Cc: stable@vger.kernel.org
> >> Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
> >> Reported-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
> >> Tested-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
> >> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
> > 
> > AFAIK, something similar is already applied to linux-media tree
> > https://git.linuxtv.org/media_tree.git/commit/?id=4f4e6644cd876c844cdb3bea2dd7051787d5ae25
> > 
> 
> Pavel,
> 
> Does the above handle the other drivers hdcs_1x00/1020 and pb01000?
> 
> Atul's patch handles those cases. If thoese code paths need to be
> fixes, Atul could do a patch on top of yours perhaps?
> 
> thanks,
> -- Shuah
> 
> 

It's not my patch. I've sent a patch sometime ago, but it was reject
by Mauro (we had a small discussion on linux-media mailing-list), then
Hans wrote the patch based on my leak discoverage.

I added Hans to CC, maybe, he will help :)


With regards,
Pavel Skripkin
