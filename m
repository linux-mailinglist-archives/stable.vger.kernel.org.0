Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF9920A36C
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391052AbgFYQ40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390448AbgFYQ4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 12:56:25 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C786C08C5C1;
        Thu, 25 Jun 2020 09:56:25 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b25so3691539ljp.6;
        Thu, 25 Jun 2020 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0kEW4FUMP8gt2vgN7gdapk4+2lvhVO5y/7YY3LT5gus=;
        b=su92Psz+lpCbzJeuoCiRMc152apsXyZ1LjpRXCdjjAvnrvYQhlPecj6k4ivQ4jWun4
         mYgYD9ZVqbb9M09vLNRWAlXtry6/5dO6ZkQNIzs07dY0tLy3Cn1CAqPzQwMfkKghCH+/
         pBrpXceZzWb0WQetcGk/G3FatciADmzeR3qq71jFt5fsuPwsdPDu/t36TPSUT42S+oNf
         Cmqs7qH+hKseTwi2qGYqmMlU8QkIrtdNTY0R5pVHsTUe2Ezin7xWxkxZPXurJruqy3gW
         L5SQhsba4Kr3JzpCNDSrNErzOePxL8IEuW28Iy5zL3gGyez4jW1PSGofBBOSItRb1Z3U
         6N+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0kEW4FUMP8gt2vgN7gdapk4+2lvhVO5y/7YY3LT5gus=;
        b=ngF3ceGkfSHOH2CAgRKvAdtwyFtUAusln9KXC8YPnNHqX0MXaymDXCen3PClB5Xl/J
         uQIk1cn2qn3HnZ1e3VxayM9a4g4ykreHmetak0a2DMh+WVdng2nknPsBVsNq28zdEjzc
         QXZincEBVFV01tQ1rkz/IAMHzkm56j7rPdFsntGyFHBow7xuheexIkDMxkvPvgaB3q5G
         Dtm9AjY6H0JL7/COsXW2kXEYht6NVIIS+i9lekqhq4mz9H4W37Ze/s/UXgxmjveAW4UV
         SSFl1R5yK2rr/wDttzXSaal5M32ZWorjNrqlb7Qmh0AkOePxWUUf21OOo2IaIjQ7Hd8p
         5boQ==
X-Gm-Message-State: AOAM530SfZswBeYUml4Lk1PQCCpHxz8TX4aXMLInQ/YhcaCdl/O6A4pO
        rsOd47RRU6guAYEFNa5FF3Q=
X-Google-Smtp-Source: ABdhPJyL+P6WaNLjzNEOxclDJJRC5dfG5zUMEyFazPEs5YNY1uXRah1xiPoWtO4JE2YP+GH9wOI57w==
X-Received: by 2002:a2e:7f0f:: with SMTP id a15mr5390539ljd.80.1593104184195;
        Thu, 25 Jun 2020 09:56:24 -0700 (PDT)
Received: from im-mac (pool-109-191-188-200.is74.ru. [109.191.188.200])
        by smtp.gmail.com with ESMTPSA id 193sm7075975lfa.90.2020.06.25.09.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 09:56:23 -0700 (PDT)
Message-ID: <779b5021239b3713c5f5c0b32a06ff8b132056c6.camel@gmail.com>
Subject: Re: [PATCH v1] drm/amd/powerplay: Fix NULL dereference in
 lock_bus() on Vega20 w/o RAS
From:   Ivan Mironov <mironov.ivan@gmail.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org,
        Bjorn Nostvold <bjorn.nostvold@gmail.com>
Date:   Thu, 25 Jun 2020 21:56:21 +0500
In-Reply-To: <20200625165042.13708-1-mironov.ivan@gmail.com>
References: <20200625165042.13708-1-mironov.ivan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Issue still reproduces on latest 5.8.0-rc2+
(8be3a53e18e0e1a98f288f6c7f5e9da3adbe9c49).

