Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790A2B3283
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 01:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfIOXBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 19:01:12 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:46501 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfIOXBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 19:01:12 -0400
Received: by mail-pf1-f180.google.com with SMTP id q5so21669836pfg.13
        for <stable@vger.kernel.org>; Sun, 15 Sep 2019 16:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Zw2XIPK2uKGZo5ZFl3Ycr8fExLmoZ+4czIWH4a74DJo=;
        b=V/h2zrU6K9EsTOF5M9UJpTDnIqnp326wB60r7cuoxUVDq0mU2YQ0foKYnLdSeozrSK
         BhtXuMuXvZrZdOp+HFZFDj1SpevLPxZz0kzR/bsLAitG/KRj6u39wqaB7Q0jztMh26fV
         wP69CGjMAOuICnvLoppmndFzS3hd+W1WY2U8KcjN5m3GCjCorQD0zXQfDBKtAekdB17F
         M3YEbYXowTsz0H4n9qWrOAygEIx63PMc4+4xXKNFFOD/ecU9izbfbmPbbShjv+mcuoGi
         0z+AERql+rcl7t6zno7SWgd4dsh0/wY9rOxJAPYW+q1ecmYa37LA+sX0ZAZVCAT31cBW
         ZIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=Zw2XIPK2uKGZo5ZFl3Ycr8fExLmoZ+4czIWH4a74DJo=;
        b=mC/vBAGLke5pi50aMZyGiaUqObRRVw+YhmsyqY7uWeXaBxI7Sugck5B2kZE92Cj90z
         zURVzWaL8yhtZoKzImBIdnPdnsFERUmUtO19NEOoNvwXLw1dJmTIaotsixZcn2djAPif
         NF8tVR5unscq7zAkaYxIHBPQVOpked4eSTxSgFCZARxaeKX+aVIT0oYE0OGfA4O1aRkK
         DTbCdCW1sNwjOkWH7etPe+VY0ifDPM/AGG4W7zr6CUX8nXlRflZb1uwfzBcV9BSShy7v
         4dLYJvnj0XJEOBpbeQTRnmctOU8O/zoNuu/xIZ12+c6i8NC41bRY0Fa2mUK8AS+sO+F1
         0XwA==
X-Gm-Message-State: APjAAAW1+TK67Gkr46bSdfw2xDqz2bhgdc3blhe6cthg8/PimHWqfG0G
        vJjXdBfQRtHIDojHsaJXzYHo3+6m
X-Google-Smtp-Source: APXvYqwjk+dDXJjIRNDuibV7RT3q8Ovmint3xZOJDZDbANEL3md3UtbTs/dlzMd4RBSscyBNCutSGA==
X-Received: by 2002:a63:7556:: with SMTP id f22mr22865827pgn.222.1568588470152;
        Sun, 15 Sep 2019 16:01:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 64sm45461661pfx.31.2019.09.15.16.01.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 16:01:09 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Maciej W. Rozycki" <macro@linux-mips.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please revert upstream commit e4849aff1e16 ("MIPS: SiByte: Enable
 swiotlb ...") in v4.4.y and v4.14.y
Message-ID: <4318a9db-0c54-319d-cc32-ed26ac95ddee@roeck-us.net>
Date:   Sun, 15 Sep 2019 16:01:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit e4849aff1e16 ("MIPS: SiByte: Enable swiotlb for SWARM,
LittleSur and BigSur") results in build failures in v4.4.y and v4.14.y.

make bigsur_defconfig:

warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)

and the actual build:

lib/swiotlb.o: In function `swiotlb_tbl_map_single':
(.text+0x1c0): undefined reference to `iommu_is_span_boundary'
Makefile:1021: recipe for target 'vmlinux' failed

Please revert.

Thanks,
Guenter

