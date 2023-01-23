Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A216773AC
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 01:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjAWA7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 19:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAWA7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 19:59:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB5212863;
        Sun, 22 Jan 2023 16:59:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A71260D30;
        Mon, 23 Jan 2023 00:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8F0C433D2;
        Mon, 23 Jan 2023 00:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674435583;
        bh=aC/7hAS/iZ638iCeHTXW7ZxH+T5LjHCoRqraTQYaT5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vChyDaPp0pQDcWsRVA8gQLuAMqBZHbaVd4R7zzukpkj5qiXLmMB/g7lE9VLrgR3Gz
         MjT7HHlzBS69JQIL7PNEX45jgNaSvNetFdHaOL+qw5xTtiz65YNqEfLQm0FbdG1LW2
         ic71fTR2o4CAsXbIqEi/EAOc21xByj86efMts4y1cS1fVCqELizyQ16aFHA9n0wIES
         USAOBzH+fFX10X7ZgEZ5kXiq6qboJBlZzoXDerc+BQSvSIAsuTvU53q099GqkcQxf0
         Jl9GpyQAroKDdT6TVkC8dX1BfJniquDxiTpJ8MgfGJd5osws0WjKuJpy9AfzN8hH7b
         73myUSQFwiKHQ==
Date:   Sun, 22 Jan 2023 19:59:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 11/17] spi: spidev: fix a race condition
 when accessing spidev->spi
Message-ID: <Y83b/lVjrlblFKwa@sashalap>
References: <20230116140448.116034-1-sashal@kernel.org>
 <20230116140448.116034-11-sashal@kernel.org>
 <Y8VhxYxMjwtu12k2@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y8VhxYxMjwtu12k2@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 02:40:05PM +0000, Mark Brown wrote:
>On Mon, Jan 16, 2023 at 09:04:42AM -0500, Sasha Levin wrote:
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> [ Upstream commit a720416d94634068951773cb9e9d6f1b73769e5b ]
>>
>> There's a spinlock in place that is taken in file_operations callbacks
>> whenever we check if spidev->spi is still alive (not null). It's also
>> taken when spidev->spi is set to NULL in remove().
>
>There are ongoing discussions of race conditions with this commit.

Okay, I've dropped it. Thanks!

-- 
Thanks,
Sasha
