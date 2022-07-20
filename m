Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B666257BE53
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiGTTV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 15:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiGTTVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 15:21:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5293313D1F;
        Wed, 20 Jul 2022 12:21:23 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e15so22259289wro.5;
        Wed, 20 Jul 2022 12:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pba4QV+WDlzTnMlWTveIRFdhe+8O4jwO+FIoxf/iMRQ=;
        b=K6/DVHdPticHrv3jCWtIj2BapqRP3uF8GYSfm12e7xSUMzoKgsMV51zpC4DV3Riuow
         0HYpqe2W/mDGhA5TC7T1PWsUL6AGMQN5kNDHFqVA3eDpL6ouczora+b5TcA//cbZmurE
         mJeeKmmISoWCXHtrYYk6Z5pux8oU5NvYtZ9iD5gDSZ4xGggmpGwk5HU8fpney8J3h88L
         DHU68uIz5TDNmCtlfhxcDYEunZhoIocRdQS9ATaOlW9zn94sX/OqsFARuYjJEWAimSos
         3IpCv96AFt21OIdNmnyL+yUfryx4QKUye1UV1vhmzuhSQv3QJ6qj5TJIQUHiHj+s5qgc
         18+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pba4QV+WDlzTnMlWTveIRFdhe+8O4jwO+FIoxf/iMRQ=;
        b=A/95ImZNPVV/uSAg8dXf0TR+LWY6/YJhW1qrbqhMR/A/3ZgRXTz3pMK1DuEkVjEvey
         f8lHGPjMA/5BcKTyBkb9p/FgL8CtLqpBMgTTUB7TPspNSc6ExpGFnPX+ESfXfNT2pe5h
         cm0BzY1Pn9Q/hTgBzNvD1h4YISjJYOyZIGMLar7ZqoYGGcv8pNHhc0G4FpNibw4d/ZAK
         Lce4Q6tIXFgK+Uc37IEM0l6sy6ldpsNs4goXSIaTnxtYIEvt5LPVDuv1OsI7APEFGeHe
         +jtZEu/XjhaQE97RiOEjeNQy1C7uFVRUsgEmLQM9IJ6FDOaK3WsuZQXKuxaqsMVK4EIk
         ux5Q==
X-Gm-Message-State: AJIora/kP0fYbulg3U6kSxLFEqCj93v8WjU7Db5TrUcMuu0ZAJYI8siK
        T/kR+XrWNzkfzxj5oleKdAYXApDc7QCp7Fqm
X-Google-Smtp-Source: AGRyM1uLOgnKXZMHCumB7qyLZW7GisJxZ81IMG3yvrEQ8OJV0MtLnu23rAmH5wRc3knjXga+LevNxg==
X-Received: by 2002:a05:6000:1f0b:b0:21d:6dae:7d04 with SMTP id bv11-20020a0560001f0b00b0021d6dae7d04mr31987220wrb.414.1658344881418;
        Wed, 20 Jul 2022 12:21:21 -0700 (PDT)
Received: from X1C7EK5 (joshua.media.unisi.it. [192.167.124.137])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a03ae64f57sm3530678wmb.8.2022.07.20.12.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 12:21:20 -0700 (PDT)
Date:   Wed, 20 Jul 2022 21:21:18 +0200
From:   Ettore Chimenti <ek5.chimenti@gmail.com>
To:     linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Hector Martin <marcan@marcan.st>, Jean Delvare <jdelvare@suse.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>,
        Marco Sogli <marco.sogli@seco.com>
Subject: Re: [PATCH v3] i2c: i801: Safely share SMBus with BIOS/ACPI
Message-ID: <20220720192118.x6ayiar7zmavhauu@X1C7EK5>
References: <20210626054113.246309-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210626054113.246309-1-marcan@marcan.st>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested on a SECO SBC-B68 and a UDOO X86.
The BIOS AML code queries the Embedded Controller over SMBus, 
respecting the hardware semaphore implementation.

I get this line on kernel log and everything works as expected.
[    7.270172] i801_smbus 0000:00:1f.3: SMBus controller is shared with ACPI AML. This seems safe so far.

Tested with continous use of i2c-tools (i2cdump) with temperature reads
in thermal_zone (that triggers AML code).

Tested-by: Ettore Chimenti <ek5.chimenti@gmail.com>
