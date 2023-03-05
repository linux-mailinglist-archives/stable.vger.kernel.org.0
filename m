Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49046AAE57
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 06:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCEFtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 00:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCEFtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 00:49:14 -0500
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 04 Mar 2023 21:49:13 PST
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FE6126FD
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 21:49:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677994446; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Z0JWuoJxgisc876J0fjgCxhLIjOxJq0s/dXYNskemo0WI4RqSA7yzl5X4ezwpB0QEDNJgHeUUtIQVbii3krPkCiNLyMStuA2mcnlpnfdKXJghxUs6dGVYOR7wxgj35krRl/9psQaTKuxOBw+lunqplskp8rVyZUGYuzASRzJ2+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1677994446; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=2WDo0yTTrOOn8be7jttBwDUclqutykGX/OkExOveoaI=; 
        b=NwoFZOrQvOu1C/rxyphAo4jmbudlLs77cxlnpoKoma8b9jBWyLJb0U70zolg299bgajkx0ajcu3Tl5QTTDGqAfGZAuizE+ZS5afX77y0dGqMepaC1GQpxtbQw17ZJQVoMqR/TM6CxsVSwi3PhvXGsUr/aRMg0n/8Ec2kcWr6Aj4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=zzy040330.moe;
        spf=pass  smtp.mailfrom=JunASAKA@zzy040330.moe;
        dmarc=pass header.from=<JunASAKA@zzy040330.moe>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1677994446;
        s=zmail; d=zzy040330.moe; i=JunASAKA@zzy040330.moe;
        h=Message-ID:Date:Date:MIME-Version:To:To:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=2WDo0yTTrOOn8be7jttBwDUclqutykGX/OkExOveoaI=;
        b=AOy4D/rzRuN41odYRO5ZVqeUaFyqe1U/4gEk6GWB8imcwyQPHaDfSj+m5iXsQkNu
        dS8voM1Bfv111fSrPyHzjj3zgCoe4dRBp6tis6UkmeN2zd755P1XYPIowq9cBOcvTK+
        6WPfLhY7ufY4PMsoj67uHQhQFSqBfRWB/N2XyDtA=
Received: from [10.8.0.2] (convallaria.eternalshinra.com [103.201.131.226]) by mx.zohomail.com
        with SMTPS id 1677994444991526.243734862991; Sat, 4 Mar 2023 21:34:04 -0800 (PST)
Message-ID: <91a734dd-a12f-54b8-0092-1da2e03e820d@zzy040330.moe>
Date:   Sun, 5 Mar 2023 13:34:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
Subject: wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 upstream.

Fixing transmission failure which results in
"authentication with ... timed out". This can be
fixed by disable the REG_TXPAUSE.

This patche should be applied to all kernel versions since the problem 
seemed to be existed since version 4.9.x.

Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>

