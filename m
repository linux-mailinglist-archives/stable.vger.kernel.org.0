Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A236D33A28C
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 05:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhCNEBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 23:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNEBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 23:01:07 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98812C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:01:06 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so847650wmq.1
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lightbitslabs-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=EpILVDXp9NhWahyeBKpbgI985goX7Y3lUfkwXN3aO40=;
        b=HJ+paIf9/XKnFQdR72mLEGwH8gfGe4oJfjp85tSm9NErlx8MnVCfnPd9CortQGtJ2t
         79yz09ikG4WvwAescIuOXVGLFdlqS7nW/R/GYEdX4ILP2zQaEifQ1zl5EipDvf6Av4LG
         4BrThlC/CI3UC0PSGYVZ2i7DUXnJmTiW7W1PK/2GwxBkN4+aw1lXb9FooNP7flA7UI8l
         atxFXFB4c/gnsM1K59BhpRJFLr3gyziIlwKczOhXkEgcLQQq0MEqIET/qFvz0TUxLykp
         WGukNUokz3Fug7Men+nyX3k6isT5Qt7taDsB2gi8Z53T7maYOoL//4yx7Ko86IjOXRLB
         gpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=EpILVDXp9NhWahyeBKpbgI985goX7Y3lUfkwXN3aO40=;
        b=aFDdyjMJwHsF4cPB/lIivhz2Knn/g7qU/lRc/gnswnprpuRr/ydFW9eOJ3LRG7Rh+v
         pqbIAmsmIo80ZpgyHfYsUL6mMt+WXLi7r6HAiVG6sML/FSFHja1fPBt20wGGHxGbuWN5
         mewsRnrFmN07S6YEAwRRfFC6Dnwv3runQbuhWfhAn7QoveP1C9Jet91oQM/EAYyMH+F+
         UiTY8JS2DicnUH8HhpVcd4pM/FnPa0yMISCOcagDsFa7z2xG965QMV7ZKm3v2qStrHq4
         LtiihAzVeS5gcwjT0CYCmhche3NqwFuUUzdQWq/9S2XWn0g3++2sChtdCkXYWwve8xF9
         vTrQ==
X-Gm-Message-State: AOAM531x9KWR4hud6P3wCp0iyvK9LS+PI0pjYTjsK4FSQPrL9VkZrP1i
        PyAdZ3BPOwSxM8DYPkUjgu3Y8MTTMEyh61ugLsurchBvKtTO/DmYD29gMfZ2U3PxP3DojsZSouy
        NU0DyNFQhylHYMrsuow==
X-Google-Smtp-Source: ABdhPJx7BUfLY1q3Weo/9azhJHa4JSV3BhKA0FpO5WpqPnmbWCJbiwVjkrISDDqQmQI32yIXDxJpcQ==
X-Received: by 2002:a1c:e389:: with SMTP id a131mr20225380wmh.78.1615694464877;
        Sat, 13 Mar 2021 20:01:04 -0800 (PST)
Received: from anton-latitude..lbits ([98.42.3.175])
        by smtp.googlemail.com with ESMTPSA id f16sm14027552wrt.21.2021.03.13.20.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 20:01:04 -0800 (PST)
From:   Anton Eidelman <anton@lightbitslabs.com>
To:     stable@vger.kernel.org
Cc:     kbusch@kernel.org, sagi@grimberg.me, hch@lst.de
Subject: nvme: ns_head vs namespace mismatch fixes
Date:   Sat, 13 Mar 2021 20:00:33 -0800
Message-Id: <20210314040035.1357617-1-anton@lightbitslabs.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please, apply the following two upstream commits (attached)
(in this order):
    d567572906d9 nvme: unlink head after removing last namespace
    ac262508daa8 nvme: release namespace head reference on error

TO: v5.4, v5.5, v5.6, v5.7
These commits are present in v5.8 and apply cleanly to the above.

Reason:
These fix a potential crash or malfunction
when an nvme namespace is deleted
and then a new namespace with the same nsid is created
before the old ns_head for this nsid is gone.

The first commit prevents the new namespace
from being matched by nvme_init_ns_head()
with the old ns_head causing ID mismatch
and consequently a failure to initialize the new namespace.

The second commit prevents ns_head refcount imbalance
in case nvme_init_ns_head() detects an ID mismatch,
and consequently a potential crash later.



-- 


*Lightbits Labs**
*Lead the cloud-native data center
transformation by 
delivering *scalable *and *efficient *software
defined storage that is 
*easy *to consume.



*This message is sent in confidence for the addressee 
only.  It
may contain legally privileged information. The contents are not 
to be
disclosed to anyone other than the addressee. Unauthorized recipients 
are
requested to preserve this confidentiality, advise the sender 
immediately of
any error in transmission and delete the email from their 
systems.*

