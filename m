Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4334C6A95F6
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCCLWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCLWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:22:00 -0500
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D849F305E5
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 03:21:58 -0800 (PST)
X-QQ-mid: bizesmtp87t1677842488tgv370fu
Received: from localhost.localdomain ( [218.59.61.106])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 03 Mar 2023 19:21:26 +0800 (CST)
X-QQ-SSF: 01200000002000B0J000B00A0000000
X-QQ-FEAT: 7jw2iSiCazrkXGfFwSRH6Xs5TMStP7RYHxFTD6Lkb75W4xjw1OXT9HtzmPWxy
        ypFMAHFAWg84JmcPmqaH3jMZKPykozvwUJj3gT1FfhloSo2PbN9Aakos3rIt6idd7Pyqj1v
        0tX1Iwdny+u/RO5ULHxVs9c+h6RY83oDd4Hpqff74nLJfkRLJsLrqFwAgH6kYQMQhnkt6PL
        7PQA52nqFSaoci7faRkw7NAjBioO3HrCV23iuO1C5yVF11A/v8vaBYdKs4Q5X5KicEL4Dbf
        +YNYPogx4JdItc3LzzFcAqPmJ6ds4tqxf9Hb9L2790AjpGzzuk7KZIPKTq5RDNAd5eju3F7
        fDUp9yCwLwk/3xAfrr8802PbCjA4J0Ehrus44O3
X-QQ-GoodBg: 0
From:   Jialu Xu <xujialu@vimux.org>
To:     cmllamas@google.com
Cc:     gregkh@linuxfoundation.org, cristian.ciocaltea@collabora.com,
        masahiroy@kernel.org, vipinsh@google.com, stable@vger.kernel.org
Subject: re: [PATCH v2] scripts/tags.sh: fix incompatibility with PCRE2
Date:   Fri,  3 Mar 2023 19:20:51 +0800
Message-Id: <20230303112051.3890371-1-xujialu@vimux.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230215183850.3353198-1-cmllamas@google.com>
References: <20230215183850.3353198-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:vimux.org:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Starting with release 10.38 PCRE2 drops default support for using \K in
> lookaround patterns as described in [1]. Unfortunately, scripts/tags.sh
> relies on such functionality to collect all_compiled_soures() leading to
> the following error:
> 
>   $ make COMPILED_SOURCE=1 tags
>     GEN     tags
>   grep: \K is not allowed in lookarounds (but see PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK)
> 
> The usage of \K for this pattern was introduced in commit 4f491bb6ea2a
> ("scripts/tags.sh: collect compiled source precisely") which speeds up
> the generation of tags significantly.
> 
> In order to fix this issue without compromising the performance we can
> switch over to an equivalent sed expression. The same matching pattern
> is preserved here except \K is replaced with a backreference \1.

Just got a working grep without \K, seems that it is three times more
efficient than sed in my test, is it necessary to update?

	grep -Poh '(?<=^  )\S+|(?<== )\S+[^\\](?=$)' {} \+ |

--
Jialu


