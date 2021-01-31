Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEF2309EB8
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhAaULs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 15:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhAaTqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 14:46:11 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C90C061573
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 09:20:30 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id h7so19577722lfc.6
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 09:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=J4+twYNb0mZJk4mxYRbnTD8Ep5+/OnLPRZ1CIGlvtVM=;
        b=GtvnJXkWK937x7lV0YFhU+tbfJMh84A4ZC+751wr/vk2R5qU5q3I3Lk+5A0RgVQ0B8
         yjj0Xw5LkP4Vj4/vKIBbVYThHenN10Hj7eflOgoeLY5BUocnE8dOuta1IrWQYz4mkdSt
         YCtXglgLi2j31Qrr8jG0u/DzsBkiuoqf+I+2G9B71JZjBlBccz5bq3PS9CKJjutWCiMv
         Ze8Jgt5CAsMByIiVd2wj2hPw9x8plbL0AJyvYipNLjm6uK9AdkvzwztegFE2lA3euaTv
         Mv8fuq/Df/37ikXlD0yrzg68/gXnOE244jkfoLnuh68poWf281x0C+n3gFgmlbqdK+JY
         5A3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=J4+twYNb0mZJk4mxYRbnTD8Ep5+/OnLPRZ1CIGlvtVM=;
        b=R2BqhAvuQsK8b94dC3ZQ2IuzK6NykQcWVYzVz5amzNQ39o6HL8/gHXml63FN7uKx35
         BGncT1gDUvLP/WXjZEc7S+zHjvh6Q13qY9qADRpaVg58JoRDg4rpjYqPNXTv0Ve0RNqk
         dZsSxX6wFjQERpGlF7oTeS68ozqNg88y/KsE/5frHGAaRNCM93nNpvdhrGHu51RuP/l+
         WvG5MepzMVAqR9nT+zVF7h+WgE3++e9iBGmuucGUfn+1/kYyI9IxVcmncYgGrsAofqkS
         VZSVsl7ChsWPWWL2aPxVRcx6jgyMhWBNSlwDZB7X4LRoLfn6GvezXxv7oar0lT2SiVKR
         iFxQ==
X-Gm-Message-State: AOAM530mhZtGliJn/D0u602m9W7pKrOAEmfAhsfkOHxiOeTqwUfuxr4W
        3QdDNTDFAyp+S/5WMJwOOvyLHtZHrGTsAyDwCkYKm3VS
X-Google-Smtp-Source: ABdhPJyYbRL7aLYl8cgfb+XZ2qN2NoCr2TBfRCFbjKeD5HS1dBBjXTvuc/iLqWtmot4oVhmLkFZfyaVnvH7gp79aDhM=
X-Received: by 2002:a19:c357:: with SMTP id t84mr6588878lff.150.1612113629128;
 Sun, 31 Jan 2021 09:20:29 -0800 (PST)
MIME-Version: 1.0
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Sun, 31 Jan 2021 12:20:18 -0500
Message-ID: <CAKf6xptBwdnhgVYgXhXRvUg9jL3TOf9hT4EcnkZFLJsVVp2M-Q@mail.gmail.com>
Subject: Request: xen: Fix XenStore initialisation for XS_LOCAL
To:     stable@vger.kernel.org,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xen: Fix XenStore initialisation for XS_LOCAL

commit 5f46400f7a6a4fad635d5a79e2aa5a04a30ffea1 upstream

The requested patch fixes Xen Dom0 xenstore support.  It has a "Fixes:
3499ba8198ca ("xen: Fix event channel callback via INTX/GSI")" in the
commit - that patch was introduced to stable in 5.4.93 and 5.10.11
(didn't check other branches).

Regards,
Jason
