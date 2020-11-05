Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60732A8522
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 18:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgKERlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 12:41:21 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:47470 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731609AbgKERlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 12:41:21 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id A4EDD182233F3;
        Thu,  5 Nov 2020 17:41:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1535:1593:1594:1605:1606:1712:1730:1747:1777:1792:2393:2559:2562:2691:2828:2829:2911:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4425:4605:4823:5007:7875:9010:10004:10848:11026:11232:11473:11658:11783:11914:12043:12295:12297:12438:12663:12679:12740:12895:13161:13229:13439:13846:13894:14659:21080:21433:21451:21627:21660:21819:30003:30022:30026:30029:30030:30041:30054:30070:30075:30083:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: vase31_190ca99272cb
X-Filterd-Recvd-Size: 5912
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Thu,  5 Nov 2020 17:41:17 +0000 (UTC)
Message-ID: <f83c2eeafdebc6307ee6e515e4d6652b2606a068.camel@perches.com>
Subject: Re: [PATCH v3] checkpatch: improve email parsing
From:   Joe Perches <joe@perches.com>
To:     Dwaipayan Ray <dwaipayanray1@gmail.com>, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com,
        yashsri421@gmail.com
Date:   Thu, 05 Nov 2020 09:41:15 -0800
In-Reply-To: <20201105115949.39474-1-dwaipayanray1@gmail.com>
References: <20201105115949.39474-1-dwaipayanray1@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(adding stable and Greg KH for additional review)
On Thu, 2020-11-05 at 17:29 +0530, Dwaipayan Ray wrote:
> checkpatch doesn't report warnings for many common mistakes
> in emails. Some of which are trailing commas and incorrect
> use of email comments.

I presume you've tested this against the git tree.

Can you send me a file with the BAD_SIGN_OFF messages generated
and if possible the git SHA-1s of the commits?

> At the same time several false positives are reported due to
> incorrect handling of mail comments. The most common of which
> is due to the pattern:
> 
> <stable@vger.kernel.org> # X.X
> 
> Improve email parsing in checkpatch.
> 
> Some general comment rules are defined:
> 
> - Multiple name comments should not be allowed.
> - Comments inside address should not be allowed.
> - In general comments should be enclosed within parentheses.
>   Exception for stable@vger.kernel.org # X.X

not just vger.kernel.org, but this should also allow stable@kernel.org
and only allow cc: and not any other -by: type for that email address.

A process preference question for Greg and the stable team:

The most common stable forms are

	stable@vger.kernel.org # version info
then
	stable@vger.kernel.org [ version info ]

with some other relatively infrequently used outlier styles, some
that use parentheses, but this is not frequent.

It might be sensible to standardize on the "# version info" trailer
comment version info style and warn on any other form.

A somewhat common style for the stable address is to use a name
before the stable address which describes the version info:

Perhaps any name before stable should be warned and the version
should be a comment.

Here's a list of the stable addresses with "version name" then
stable address in the git tree and other outlier styles.

     24 linux-stable <stable@vger.kernel.org>
     21 5.4+ <stable@vger.kernel.org>
     14 All applicable <stable@vger.kernel.org>
      6 3.10+ <stable@vger.kernel.org>
      5 5.9+ <stable@vger.kernel.org>
      5 5.3+ <stable@vger.kernel.org>
      5 5.1+ <stable@vger.kernel.org>
      4 5.6+ <stable@vger.kernel.org>
      4 4.20+ <stable@vger.kernel.org>
      3 Stable Team <stable@vger.kernel.org>
      3 4.19+ <stable@vger.kernel.org>
      3 4.15+ <stable@vger.kernel.org>
      3 4.10+ <stable@vger.kernel.org>
      2 stable@vger.kernel.org (v2.6.12+)
      2 5.2+ <stable@vger.kernel.org>
      2 4.16+ <stable@vger.kernel.org>
      1 v5.8+ <stable@vger.kernel.org>
      1 v5.7+ <stable@vger.kernel.org>
      1 v5.6+ <stable@vger.kernel.org>
      1 v5.3+ <stable@vger.kernel.org>
      1 v5.0+ <stable@vger.kernel.org>
      1 v4.9+ <stable@vger.kernel.org>
      1 <stable@vger.kernel.org> v5.0+
      1 <stable@vger.kernel.org> +v4.18
      1 stable@vger.kernel.org (3.14+)
      1 5.8+ <stable@vger.kernel.org>
      1 5.5+ <stable@vger.kernel.org>
      1 5.0+ <stable@vger.kernel.org>
      1 4.18+ <stable@vger.kernel.org>
      1 4.14+ <stable@vger.kernel.org>
      1 4.13+ <stable@vger.kernel.org>
      1 4.0+ <stable@vger.kernel.org>
      1 3.15+ <stable@vger.kernel.org>
      1 3.11+ <stable@vger.kernel.org>

> Improvements to parsing:
> 
> - Detect and report unexpected content after email.
> - Quoted names are excluded from comment parsing.
> - Trailing dots or commas in email are removed during
>   formatting. Correspondingly a BAD_SIGN_OFF warning
>   is emitted.
> - Improperly quoted email like '"name <address>"' are now
>   warned about.

All of the above seems right but perhaps the comment style for any
<foo>-by: lines should also allow # comments.

The below is just comments on the patch itself.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2800,9 +2806,57 @@ sub process {
>  				$dequoted =~ s/" </ </;
>  				# Don't force email to have quotes
>  				# Allow just an angle bracketed address
> -				if (!same_email_addresses($email, $suggested_email, 0)) {
> +				if (!same_email_addresses($email, $suggested_email)) {
> +					if (WARN("BAD_SIGN_OFF",
> +					    "email address '$email' might be better as '$suggested_email'\n" . $herecurr) &&
> +						$fix) {

trivia:

Please always align $fix with tabs to the if and then 4 spaces to the
open parenthesis.

> +				# Comments must begin only with (
> +				# or # in case of stable@vger.kernel.org
> +				if ($email =~ /^.*stable\@vger/) {

I believe this should be

				if ($email =~ /^stable\@(?:vger\.)?kernel.org$/) {

> +					if ($comment ne "" && $comment !~ /^#.+/) {
> +						if (WARN("BAD_SIGN_OFF",
> +						    "Invalid comment format for stable: '$email', prefer parentheses\n" . $herecurr) &&

Prefer #

> +							$fix) {
> +							my $new_comment = $comment;
> +							$new_comment =~ s/^[ \(\[]+|[ \)\]]+$//g;

Does the comment include any leading whitespace here?
I presumed not given the $comment !~ /^#/ test above.


