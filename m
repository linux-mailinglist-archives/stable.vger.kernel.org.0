Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46986C6B0A
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 15:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCWOcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 10:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCWOcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 10:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD031F490;
        Thu, 23 Mar 2023 07:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B0726276A;
        Thu, 23 Mar 2023 14:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76DCC433EF;
        Thu, 23 Mar 2023 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679581949;
        bh=HHWrNMrPlNwL81CabBt0+fkOmCZiHtHeEc00qjEhBTE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kEn9mn0wY9dmxlUr9qFUf+dpySxwscUg07B4sar7MR0Wx0CTG13oBMTAM/oPBp0Cg
         EkuTrNgG1ULF4umJ4seD677BShuGXEgqwInyYnKon/DxmfTMxx7N3s0mWkuLM0FSGI
         NcIWl3UKC2KnXWyfrZaKWzQh7LA8fARh6SZkicPGb+IIzYDO+KnSkzkwGxiEHXa6O0
         HbvnUksEqKuPJvnyYpjxgRs3OsvNlc6TxnNbvc/RWCt3RjN7TS+UpkNt5i4KE1xYT9
         1BmEggt8owjnw4Y0HrjCwEfGvV+gniqfh08Y1OvyBK3iTXHqd3v/b20bHldDzsdIGS
         6V2kXDXQGvOEA==
Message-ID: <a58bbd47-6390-91b5-b00c-0399362c95c7@kernel.org>
Date:   Thu, 23 Mar 2023 22:32:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [f2fs-dev] [PATCH 3/3] f2fs: remove entire rb_entry sharing
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230313201216.924234-1-jaegeuk@kernel.org>
 <20230313201216.924234-4-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230313201216.924234-4-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/3/14 4:12, Jaegeuk Kim wrote:
> This is a last part to remove the memory sharing for rb_tree in extent_cache.
> 
> This should also fix arm32 memory alignment issue.
> 
> [struct extent_node]               [struct rb_entry]
> [0] struct rb_node rb_node;        [0] struct rb_node rb_node;
>    union {                              union {
>      struct {                             struct {
> [16]  unsigned int fofs;           [12]    unsigned int ofs;
>        unsigned int len;                    unsigned int len;
>                                           };
>                                           unsigned long long key;
>                                         } __packed;
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 13054c548a1c ("f2fs: introduce infra macro and data structure of rb-tree extent cache")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
