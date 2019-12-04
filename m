Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8D112EF4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfLDPvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:51:33 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40101 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbfLDPvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 10:51:33 -0500
Received: by mail-pf1-f193.google.com with SMTP id q8so46195pfh.7;
        Wed, 04 Dec 2019 07:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=5ysUJsELO1ZM9MQnRAeaIoc7Nsf0kwXFJFQgtF5DDrc=;
        b=vJM9OhZbApPtC0MItVItG7kzERfpevGB5B4fq6y+ZdX3b/FqLkjdfoa8s7XIDtY2Ze
         f1VDiPXsDgGB/uA1Oidcc1JxgQHNduPDK2cb4qFLcIaH/SQypWjWESIu/HY/Gh4zFlmW
         6RH33lMfwbCGTsy8Qur2YXPgw754mK1R2BZeUP4OkKmtUqI2Q7r1bFKXWYX+9WCo2ifr
         9/M7+UkzK/78yVbNsmCXQTftkcEVHBiS1yRkgiuHNbF32qLqc1SA9gor3thyWTgu+WDJ
         eIOr2S7n6YHaYaduBc2P92E2xTXTOUsZFNvWso37i8/xYskRFMLnV2fkwSpr6D7Ei4Z8
         oo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5ysUJsELO1ZM9MQnRAeaIoc7Nsf0kwXFJFQgtF5DDrc=;
        b=nnDiTOrkX7k8LtWqKcqopR56s2OvyABhzGFIvxV6uG89tesixbIEGlaA3qlMdrtib1
         /7XWGnu/MhCEklFxFsrh8PxUp8Istnn5z08zN08sowIcWlaamupF5MTlTLDRtEbujm+x
         XaapzjT+H9bsYm93OgEsCC+RP2jVUMBj1OEgjN55GLOIJ/ZdPjzzZhzQioF0pFrHksXw
         X/VmgkjqmzjP8KO9ipOf7oDXzSmc7tcd43pN58lj2DklVkIi/CpjMYx0OqR1Om0ll9Tq
         5sFScKs3zA4mId/Hzs6SiCzuRaoQYBe4sVsbJfTQuGAKgTKv5wUcQJoSk+ZaaHf4Udwy
         U8aA==
X-Gm-Message-State: APjAAAVzVPpsn/gnlea6QsJKQ8oip2rmqPmV8wWzsg2TKeMrjK+7jkyf
        UMr0NXhzv6lf7TKG9dw+xw8=
X-Google-Smtp-Source: APXvYqxduuYANVN21ivuLEuZ6kDH1FV9esMxOY6viym6WqyBRRT6K7OiGfF3Am+P6w+21r9DRWlZOA==
X-Received: by 2002:a63:5442:: with SMTP id e2mr2897040pgm.18.1575474692288;
        Wed, 04 Dec 2019 07:51:32 -0800 (PST)
Received: from iclxps ([155.98.131.2])
        by smtp.gmail.com with ESMTPSA id d85sm8886344pfd.146.2019.12.04.07.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 07:51:31 -0800 (PST)
Message-ID: <7eb0ed7d51b53f7d720a78d9b959c462adb850d4.camel@gmail.com>
Subject: Re: [PATCH v5 2/4] lib: devres: add a helper function for ioremap_uc
From:   Tuowen Zhao <ztuowen@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org, linux@roeck-us.net
Date:   Wed, 04 Dec 2019 08:51:30 -0700
In-Reply-To: <20191018164738.GY31224@sasha-vm>
References: <20191016210629.1005086-3-ztuowen@gmail.com>
         <20191017143144.9985421848@mail.kernel.org>
         <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
         <20191018164738.GY31224@sasha-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Sorry to bother. Can I ask for patches in this series to NOT be applied
to stable?

They causes build failure on Hexagon.

Relevant patches include

sparc64: implement ioremap_uc
lib: devres: add a helper function for ioremap_uc
mfd: intel-lpss: Use devm_ioremap_uc for MMIO

Best,
Tuowen

