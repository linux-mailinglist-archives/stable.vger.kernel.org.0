Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1DF347EE6
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 18:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhCXRKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 13:10:09 -0400
Received: from 99-33-87-210.lightspeed.sntcca.sbcglobal.net ([99.33.87.210]:32782
        "EHLO mail.aaazen.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbhCXRIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 13:08:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 13:08:35 EDT
Received: from localhost (localhost [127.0.0.1])
        by thursday.test (OpenSMTPD) with ESMTP id 33db7abc;
        Wed, 24 Mar 2021 17:01:50 +0000 (UTC)
Date:   Wed, 24 Mar 2021 10:01:50 -0700 (PDT)
From:   Richard Narron <richard@aaazen.com>
X-X-Sender: richard@thursday.test
To:     stable <stable@vger.kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 5.11 093/120] iio: adc: adi-axi-adc: add proper Kconfig
 dependencies
In-Reply-To: <20210322121932.787548436@linuxfoundation.org>
Message-ID: <alpine.LNX.2.20.2103240935480.7053@thursday.test>
References: <20210322121929.669628946@linuxfoundation.org> <20210322121932.787548436@linuxfoundation.org>
User-Agent: Alpine 2.20 (LNX 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch gives me a new error message building 5.11.9 on x86_64
using the Slackware current 5.11.8 config:

$make oldconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/confdata.o
  HOSTCC  scripts/kconfig/expr.o
  LEX     scripts/kconfig/lexer.lex.c
  HOSTCC  scripts/kconfig/preprocess.o
  YACC    scripts/kconfig/parser.tab.[ch]
  HOSTCC  scripts/kconfig/util.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTLD  scripts/kconfig/conf

WARNING: unmet direct dependencies detected for ADI_AXI_ADC
  Depends on [n]: IIO [=m] && HAS_IOMEM [=y] && OF [=n]
  Selected by [m]:
  - AD9467 [=m] && IIO [=m] && SPI [=y]

WARNING: unmet direct dependencies detected for ADI_AXI_ADC
  Depends on [n]: IIO [=m] && HAS_IOMEM [=y] && OF [=n]
  Selected by [m]:
  - AD9467 [=m] && IIO [=m] && SPI [=y]
#
# configuration written to .config
#

The Slackware 5.11.8 config is here:

https://mirrors.kernel.org/slackware/slackware64-current/testing/source/linux-5.11.x/kernel-configs/config-huge-5.11.8.x64

It looks like a similar bug was found earlier:

https://lkml.org/lkml/2021/3/17/231
